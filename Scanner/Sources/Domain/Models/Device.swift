//
//  Device.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import Foundation
import MMLanScan

enum DeviceType: Codable {
    case bluetooth
    case lan
}

struct Device: Codable, Identifiable, Hashable {
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
    
    init(from device: LanDevice) {
        id = UUID()
        name = device.hostname
        rssi = nil
        date = Date()
        type = .lan
        ipAddress = device.ipAddress
        mac = device.macAddress
        brand = device.brand ?? "Unknown"
        isSecure = mac != nil
    }
}
