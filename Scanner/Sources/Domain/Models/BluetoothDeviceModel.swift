//
//  BluetoothDeviceModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import Foundation

struct BluetoothDeviceModel: Codable, Equatable {
    let id: UUID
    let name: String?
    var rssi: Int?
}
