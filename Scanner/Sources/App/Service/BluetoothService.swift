//
//  BluetoothService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI
import CoreBluetooth

struct BluetoothDevice {
    var peripheral: CBPeripheral
    var rssi: NSNumber
    var advertisedData: String
}

class BluetoothService: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredDevices = [BluetoothDevice]()
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
        var advertisedData = advertisementData.map { "\($0): \($1)" }.sorted(by: { $0 < $1 }).joined(separator: "\n")
        let timestampValue = advertisementData["kCBAdvDataTimestamp"] as! Double
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: timestampValue))
        advertisedData = "actual rssi: \(RSSI) dB\n" + "Timestamp: \(dateString)\n" + advertisedData
        if !discoveredDevicesSet.contains(peripheral) {
            discoveredDevices.append(
                BluetoothDevice(
                    peripheral: peripheral,
                    rssi: RSSI,
                    advertisedData: advertisedData
                )
            )
            discoveredDevicesSet.insert(peripheral)
            objectWillChange.send()
        } else {
            if let index = discoveredDevices.firstIndex(where: { $0.peripheral == peripheral }) {
                discoveredDevices[index].advertisedData = advertisedData
                objectWillChange.send()
            }
        }
    }
}
