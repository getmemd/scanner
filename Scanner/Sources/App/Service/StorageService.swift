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
        static let historyForDevices = "HistoryForDevices"
    }
    
    private let userDefaults = UserDefaults.standard

    func removeHistory() {
        userDefaults.removeObject(forKey: Keys.historyForDevices)
    }
    
    func removeHistoryItem(id: UUID) {
        var devices = getHistory()
        for (index, device) in devices.enumerated() {
            if device.id == id {
                devices.remove(at: index)
            }
        }
        setHistory(data: devices)
    }
    
    func getHistory() -> [Device] {
        loadData(forKey: Keys.historyForDevices) ?? []
    }
    
    func setHistory(data: [Device]) {
        saveData(data, forKey: Keys.historyForDevices)
    }
    
    func updateDevice(id: UUID) {
        var devices = getHistory()
        for (index, device) in devices.enumerated() {
            if device.id == id {
                devices[index].isSecure.toggle()
            }
        }
        setHistory(data: devices)
    }
    
    func checkSecure(devices: inout [Device]) {
        let history = StorageService.shared.getHistory()
        for (index, device) in devices.enumerated() {
            if let historyDevice = history.first(where: { $0.id == device.id }) {
                if historyDevice.isSecure != device.isSecure {
                    devices[index].isSecure = historyDevice.isSecure
                }
            }
        }
        var updatedHistory = history + devices
        updatedHistory = updatedHistory.removingDuplicates {
            $0.id == $1.id && Calendar.current.isDate($0.date, inSameDayAs: $1.date)
        }
        StorageService.shared.setHistory(data: updatedHistory)
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
