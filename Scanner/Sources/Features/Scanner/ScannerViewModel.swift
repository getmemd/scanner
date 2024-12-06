//
//  ScannerViewModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import MMLanScan
import CoreBluetooth
import Network

final class ScannerViewModel: NSObject, ObservableObject {
    @Published var connectedDevices = [Device]()
    @Published var scanProgress: Double = 0.0
    @Published var isLanScanning: Bool = false
    @Published var isBluetoothScanning: Bool = false
    @Published var isNavigatingToResults = false
    @Published var showAlert = false
    
    private var isBluetoothScanRequested: Bool = false
    
    private var bluetoothTimer: Timer?
    
    private lazy var scanner = LanScanner(delegate: self)
    private let localNetworkAuthorization = LocalNetworkAuthorization()
    
    private var centralManager: CBCentralManager?
    
    func startLanScan() {
        checkConnection()
        connectedDevices.removeAll()
        scanProgress = 0
        localNetworkAuthorization.requestAuthorization { [weak self] isAuthorized in
            if isAuthorized {
                self?.isLanScanning = true
                self?.scanner.start()
            } else {
                self?.showAlert = true
                self?.stopLanScan()
            }
        }
    }
    
    func startBluetoothScan() {
        switch CBCentralManager.authorization {
        case .notDetermined, .allowedAlways:
            break
        default:
            showAlert = true
            return
        }
        isBluetoothScanning = true
        if centralManager == nil {
            centralManager = .init(delegate: self, queue: nil)
            isBluetoothScanRequested = true
        } else {
            performBluetoothScan()
        }
        connectedDevices.removeAll()
    }
    
    func performBluetoothScan() {
        scanProgress = 0.0
        centralManager?.scanForPeripherals(withServices: nil)
        let scanDuration: TimeInterval = 10.0
        let progressUpdateInterval: TimeInterval = 0.1
        var elapsedTime: TimeInterval = 0.0
        
        bluetoothTimer = Timer.scheduledTimer(withTimeInterval: progressUpdateInterval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            elapsedTime += progressUpdateInterval
            self.scanProgress = min(elapsedTime / scanDuration, 1.0)
            if elapsedTime >= scanDuration {
                timer.invalidate()
                self.bluetoothTimer = nil
                self.stopBluetoothScan()
                self.checkSecure()
                self.isNavigatingToResults = true
            }
        }
    }
    
    func stopLanScan() {
        scanProgress = 0
        isLanScanning = false
        scanner.stop()
    }
    
    func stopBluetoothScan() {
        bluetoothTimer?.invalidate()
        bluetoothTimer = nil
        scanProgress = 0
        isBluetoothScanning = false
        centralManager?.stopScan()
        centralManager = nil
    }
    
    func getIpAddress() -> String? {
        var address : String?
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                } else if (name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3") {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(1), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    private func checkConnection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied && path.usesInterfaceType(.wifi) {
                print("Устройство подключено к Wi-Fi.")
            } else {
                print("Устройство не подключено к Wi-Fi.")
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.stopLanScan()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func checkSecure() {
        StorageService.shared.checkSecure(devices: &connectedDevices)
    }
}

// MARK: - LanScannerDelegate

extension ScannerViewModel: LanScannerDelegate {
    func lanScanDidFindNewDevice(_ device: LanDevice) {
        let newDevice = Device(from: device)
        if let index = connectedDevices.firstIndex(where: { $0.ipAddress == device.ipAddress }) {
            connectedDevices[index] = newDevice
        } else {
            connectedDevices.append(newDevice)
        }
    }

    func lanScanDidFinishScanning(with status: LanScannerStatus) {
        switch status {
        case .finished:
            checkSecure()
            isLanScanning = false
            isNavigatingToResults = true
            scanProgress = 0
        case .cancelled:
            break
        }
    }

    func lanScanDidFailedToScan() {
        showAlert = true
        stopLanScan()
    }
    
    func lanScanDidUpdateProgress(_ progress: Float, overall: Int) {
        scanProgress = Double(progress) / Double(overall)
    }
}

// MARK: - CBCentralManagerDelegate

extension ScannerViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if isBluetoothScanRequested {
                isBluetoothScanRequested = false
                performBluetoothScan()
            }
        default:
            showAlert = true
            stopBluetoothScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        if let error = error {
            print("Failed to connect to peripheral: \(error.localizedDescription)")
        }
        showAlert = true
        stopBluetoothScan()
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        if let index = connectedDevices.firstIndex(where: { $0.id == peripheral.identifier }) {
            connectedDevices[index].rssi = RSSI.intValue
        } else {
            connectedDevices.append(Device(id: peripheral.identifier, name: peripheral.name, rssi: RSSI.intValue))
        }
    }
}
