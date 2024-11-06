//
//  BluetoothDeviceModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import Foundation

struct BluetoothDeviceModel: Codable, Equatable {
    var id: UUID
    var name: String?
    var rssi: Int
}
