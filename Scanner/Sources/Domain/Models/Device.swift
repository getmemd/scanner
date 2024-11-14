//
//  Device.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import Foundation

struct Device<T: Codable>: Codable, Identifiable {
    var id = UUID()
    var device: T
    var date: Date
    var isSecure: Bool = false
}
