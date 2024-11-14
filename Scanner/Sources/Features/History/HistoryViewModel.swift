//
//  HistoryViewModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import Foundation

final class HistoryViewModel: ObservableObject {
    @Published var bleDevicesByDate: [Date: [Device<BluetoothDeviceModel>]] = [:]
    @Published var lanDevicesByDate: [Date: [Device<LanDeviceModel>]] = [:]
    
    var sortedBleDates: [Date] {
        bleDevicesByDate.keys.sorted(by: >)
    }
    
    var sortedLanDates: [Date] {
        lanDevicesByDate.keys.sorted(by: >)
    }
    
    init() {
        loadHistory()
    }
    
    func loadHistory() {
        let bleDevices = StorageService.shared.getHistoryDataForBluetooth() ?? []
        let lanDevices = StorageService.shared.getHistoryDataForWifi() ?? []
        bleDevicesByDate = groupDevicesByDay(devices: bleDevices)
        lanDevicesByDate = groupDevicesByDay(devices: lanDevices)
    }
    
    private func groupDevicesByDay<T>(devices: [Device<T>]) -> [Date: [Device<T>]] {
        let calendar = Calendar.current
        return Dictionary(grouping: devices) { device in
            calendar.startOfDay(for: device.date)
        }
    }
}
