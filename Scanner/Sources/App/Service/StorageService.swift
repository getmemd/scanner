//
//  StorageService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 09.11.2024.
//

import Foundation

final class StorageService {
    static let shared = StorageService()
    
    private enum Keys {
        static let historyForBluetooth = "HistoryForBluetooth"
        static let historyForWifi = "HistoryForWifi"
        static let onboardingShowed = "OnboardingShowed"
        static let firstTime = "FirstTime"
    }
    
    private let userDefaults = UserDefaults.standard
    
    func isFirstTime() -> Bool {
        userDefaults.bool(forKey: Keys.firstTime) == false ? false : true
    }
    
    func setFirstTime() {
        userDefaults.set(false, forKey: Keys.firstTime)
    }
    
    func setHistoryForWifi(_ data: [Device<LanDeviceModel>]) {
        saveData(data, forKey: Keys.historyForWifi)
    }
    
    func setHistoryForBluetooth(_ data: [Device<BluetoothDeviceModel>]) {
        saveData(data, forKey: Keys.historyForBluetooth)
    }
    
    func removeWifi() {
        userDefaults.removeObject(forKey: Keys.historyForWifi)
    }
    
    func removeBluetooth() {
        userDefaults.removeObject(forKey: Keys.historyForBluetooth)
    }
    
    func removeAll() {
        removeWifi()
        removeBluetooth()
    }
    
    func updateSpecificById(id: UUID) {
        var bleDevices = getHistoryDataForBluetooth()
        for (index, device) in bleDevices?.enumerated() ?? [].enumerated() {
            if device.device.id == id {
                bleDevices?[index].isSecure.toggle()
            }
        }
        setHistoryForBluetooth(bleDevices ?? [])
    }

    func updateSpecificByIp(ipAddress: String) {
        var lanDevices = getHistoryDataForWifi()
        for (index, device) in lanDevices?.enumerated() ?? [].enumerated() {
            if device.device.ipAddress == ipAddress {
                lanDevices?[index].isSecure.toggle()
            }
        }
        setHistoryForWifi(lanDevices ?? [])
    }
    
    func getHistoryDataForWifi() -> [Device<LanDeviceModel>]? {
        loadData(forKey: Keys.historyForWifi)
    }
    
    func getHistoryDataForBluetooth() -> [Device<BluetoothDeviceModel>]? {
        loadData(forKey: Keys.historyForBluetooth)
    }
    
    private func saveData<T: Codable>(_ data: [T], forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Failed to save data for key \(key): \(error.localizedDescription)")
        }
    }
    
    private func loadData<T: Codable>(forKey key: String) -> [T]? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("Failed to load data for key \(key): \(error.localizedDescription)")
            return nil
        }
    }
}
