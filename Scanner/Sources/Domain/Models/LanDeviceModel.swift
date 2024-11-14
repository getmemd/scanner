//
//  LanDeviceModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import Foundation

struct LanDeviceModel: Codable {
    let name: String
    let ipAddress: String
    let mac: String?
    let brand: String
    
    init(device: [AnyHashable: String]) {
        ipAddress = device[DEVICE_IP_ADDRESS] ?? "Unknown"
        name = device[DEVICE_NAME] ?? "Unknown"
        mac = device[DEVICE_MAC]
        brand = device[DEVICE_BRAND] ?? "Unknown"
    }
}
