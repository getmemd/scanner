//
//  BluetoothService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI
import CoreBluetooth

class BluetoothService: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredDevices = [Device<BluetoothDeviceModel>]()
    @Published var isScanning = false
    
    var centralManager: CBCentralManager!
    var discoveredDevicesSet = Set<CBPeripheral>()
    var timer: Timer?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScan() {
        if centralManager.state == .poweredOn {
            isScanning = true
            discoveredDevices.removeAll()
            discoveredDevicesSet.removeAll()
            objectWillChange.send()
            centralManager.scanForPeripherals(withServices: nil)
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
                self?.centralManager.stopScan()
                self?.centralManager.scanForPeripherals(withServices: nil)
            }
        }
    }

    func stopScan() {
        isScanning = false
        timer?.invalidate()
        centralManager.stopScan()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) { }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        if !discoveredDevicesSet.contains(peripheral) {
            discoveredDevices.append(
                Device(device: BluetoothDeviceModel(id: peripheral.identifier, name: peripheral.name, rssi: RSSI.intValue), isSecure: true)
            )
            discoveredDevicesSet.insert(peripheral)
            objectWillChange.send()
        } else {
            if let index = discoveredDevices.firstIndex(where: { $0.id == peripheral.identifier }) {
                discoveredDevices[index].device.rssi = RSSI.intValue
                objectWillChange.send()
            }
        }
    }
}
