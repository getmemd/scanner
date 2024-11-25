//
//  HistoryViewModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI

final class HistoryViewModel: ObservableObject {
    @Published var devices: [Device] = []
    @Published var showAlert = false
    
    var groupedDevices: [String: [Device]] {
        Dictionary(grouping: devices, by: { device in
            return device.date.formatted(date: .long, time: .omitted)
        })
    }
    
    init() {
        loadHistory()
    }
    
    func loadHistory() {
        devices = StorageService.shared.getHistory().sorted {
            $0.date > $1.date
        }
    }
    
    func clearHistory() {
        StorageService.shared.removeHistory()
        devices = []
    }
    
    func deleteItems(in dateKey: String, at offsets: IndexSet) {
        var id: UUID = UUID()
        if let devicesForDate = groupedDevices[dateKey] {
            for offset in offsets {
                if let index = devices.firstIndex(where: { $0.id == devicesForDate[offset].id }) {
                    devices.remove(at: index)
                    id = devicesForDate[offset].id
                }
            }
        }
        StorageService.shared.removeHistoryItem(id: id)
    }
}
