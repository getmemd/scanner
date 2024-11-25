//
//  DeviceManager.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 18.11.2024.
//

import Foundation

final class DeviceManager: ObservableObject {
    @Published var devices: [Device]
    
    init(devices: [Device] = []) {
        self.devices = devices
    }
    
    func toggleSecureStatus(for device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].isSecure.toggle()
        }
    }
    
    func devicesFiltered(by isSecure: Bool) -> [Device] {
        devices.filter { $0.isSecure == isSecure }
    }
    
    func deleteDevice(_ device: Device) {
        devices.removeAll { $0.id == device.id }
    }
}
