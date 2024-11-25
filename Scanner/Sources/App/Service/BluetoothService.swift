//
//  BluetoothService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import CoreBluetooth

final class BluetoothService: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredDevices = [Device]()
    @Published var isScanning = false

    var askPermission: (() -> Void)?
    var centralManager: CBCentralManager!
    private var discoveredDevicesDict = [CBPeripheral: Device]()

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        isScanning = true
        discoveredDevices.removeAll()
        discoveredDevicesDict.removeAll()
        centralManager.scanForPeripherals(withServices: nil)
    }

    func stopScan() {
        guard isScanning else { return }
        isScanning = false
        centralManager.stopScan()
    }

    deinit {
        stopScan()
    }

    func checkSecure() {
        StorageService.shared.checkSecure(devices: &discoveredDevices)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on. Ready to scan.")
        case .poweredOff, .resetting, .unauthorized, .unsupported, .unknown:
            askPermission?()
        @unknown default:
            askPermission?()
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        if let existingDevice = discoveredDevicesDict[peripheral] {
            var updatedDevice = existingDevice
            updatedDevice.rssi = RSSI.intValue
            discoveredDevicesDict[peripheral] = updatedDevice
            discoveredDevices = Array(discoveredDevicesDict.values)
        } else {
            let newDevice = Device(id: peripheral.identifier, name: peripheral.name, rssi: RSSI.intValue)
            discoveredDevicesDict[peripheral] = newDevice
            discoveredDevices = Array(discoveredDevicesDict.values)
        }
    }
}
