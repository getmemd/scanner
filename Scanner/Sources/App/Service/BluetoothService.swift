//
//  BluetoothService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI
import CoreBluetooth

final class BluetoothService: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredDevices = [Device<BluetoothDeviceModel>]()
    @Published var isScanning = false
    
    var centralManager: CBCentralManager!
    private var discoveredDevicesDict = [CBPeripheral: Device<BluetoothDeviceModel>]()
    
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
        guard let bluetoothHistory = StorageService.shared.getHistoryDataForBluetooth() else { return }
        DispatchQueue.main.async {
            for (index, device) in self.discoveredDevices.enumerated() {
                if let historyDevice = bluetoothHistory.first(where: { $0.device.id == device.device.id }) {
                    if historyDevice.isSecure != device.isSecure {
                        self.discoveredDevices[index].isSecure = historyDevice.isSecure
                    }
                }
            }
            let modifiedDevices = self.discoveredDevices.map { device in
                var modifiedDevice = device
                modifiedDevice.device.rssi = nil
                return modifiedDevice
            }
            var updatedHistory = bluetoothHistory + modifiedDevices
            updatedHistory = updatedHistory.removingDuplicates {
                $0.device.id == $1.device.id && Calendar.current.isDate($0.date, inSameDayAs: $1.date)
            }
            StorageService.shared.setHistoryForBluetooth(updatedHistory)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) { }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        if let existingDevice = discoveredDevicesDict[peripheral] {
            var updatedDevice = existingDevice
            updatedDevice.device.rssi = RSSI.intValue
            discoveredDevicesDict[peripheral] = updatedDevice
            discoveredDevices = Array(discoveredDevicesDict.values)
        } else {
            let device = BluetoothDeviceModel(id: peripheral.identifier, name: peripheral.name, rssi: RSSI.intValue)
            let newDevice = Device(device: device, date: Date(), isSecure: device.name != nil)
            discoveredDevicesDict[peripheral] = newDevice
            discoveredDevices = Array(discoveredDevicesDict.values)
        }
    }
}
