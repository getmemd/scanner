//
//  DeviceManager.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 18.11.2024.
//

import Foundation

final class DeviceManager<T: Codable>: ObservableObject {
    @Published var devices: [Device<T>]
    
    init(devices: [Device<T>] = []) {
        self.devices = devices
    }
    
    func toggleSecureStatus(for device: Device<T>) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].isSecure.toggle()
        }
    }
    
    func devicesFiltered(by isSecure: Bool) -> [Device<T>] {
        devices.filter { $0.isSecure == isSecure }
    }
    
    func deleteDevice(_ device: Device<T>) {
        devices.removeAll { $0.id == device.id }
    }
}
