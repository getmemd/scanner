//
//  Device.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import Foundation

enum DeviceType: Codable {
    case bluetooth
    case lan
}

struct Device: Codable, Identifiable {
    var id = UUID()
    let date: Date
    var isSecure: Bool = false
    let type: DeviceType
    let name: String?
    var rssi: Int?
    let ipAddress: String
    let mac: String?
    let brand: String
    
    init(id: UUID, name: String?, rssi: Int) {
        self.id = id
        self.name = name
        self.rssi = rssi
        date = Date()
        type = .bluetooth
        ipAddress = "Unknown"
        mac = nil
        brand = "Unknown"
        isSecure = name != nil
    }
    
    init(data: [AnyHashable: String]) {
        date = Date()
        type = .lan
        ipAddress = data[DEVICE_IP_ADDRESS] ?? "Unknown"
        name = data[DEVICE_NAME] ?? "Unknown"
        mac = data[DEVICE_MAC]
        brand = data[DEVICE_BRAND] ?? "Unknown"
        isSecure = mac != nil
    }
}
