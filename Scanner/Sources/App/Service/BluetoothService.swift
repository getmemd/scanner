//
//  BluetoothService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI
import CoreBluetooth

final class BluetoothService: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredDevices = [Device]()
    @Published var isScanning = false
    
    var centralManager: CBCentralManager!
    private var discoveredDevicesDict = [CBPeripheral: Device]()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private var scanTimer: DispatchSourceTimer?
    
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        isScanning = true
        discoveredDevices.removeAll()
        discoveredDevicesDict.removeAll()
        centralManager.scanForPeripherals(withServices: nil)
        scanTimer?.cancel()
        scanTimer = DispatchSource.makeTimerSource()
        scanTimer?.schedule(deadline: .now(), repeating: 2.0)
        scanTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.centralManager.stopScan()
            self.centralManager.scanForPeripherals(withServices: nil)
        }
        scanTimer?.resume()
    }
    
    func stopScan() {
        isScanning = false
        scanTimer?.cancel()
        scanTimer = nil
        centralManager.stopScan()
    }
    
    deinit {
        stopScan()
    }
    
    func checkSecure() {
        StorageService.shared.checkSecure(devices: &discoveredDevices)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) { }
    
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
