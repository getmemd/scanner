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
            if $0.isSecure != $1.isSecure {
                return !$0.isSecure && $1.isSecure
            } else {
                return $0.date > $1.date
            }
        }
    }
    
    func clearHistory() {
        StorageService.shared.removeHistory()
        devices = []
    }
    
    func deleteItem(device: Device) {
        if let index = devices.firstIndex(of: device) {
            devices.remove(at: index)
        }
        StorageService.shared.removeHistoryItem(device: device)
    }
}
