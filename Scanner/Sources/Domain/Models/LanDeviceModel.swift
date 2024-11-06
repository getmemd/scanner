//
//  LanDeviceModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import LanScanner

struct LanDeviceModel: Codable {
    let name: String
    let ipAddress: String
    let mac: String
    let brand: String
    
    init(from lanDevice: LanDevice) {
        self.name = lanDevice.name
        self.ipAddress = lanDevice.ipAddress
        self.mac = lanDevice.mac
        self.brand = lanDevice.brand
    }
}
