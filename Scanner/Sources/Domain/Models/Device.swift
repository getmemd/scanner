//
//  Device.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import Foundation
import LanScanner

struct Device<T: Codable>: Codable, Identifiable {
    var id = UUID()
    var device: T
    var isSecure: Bool
}
