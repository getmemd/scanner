//
//  MagnetometorService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 03.11.2024.
//

import SwiftUI
import CoreMotion

final class MagnetometorService: ObservableObject {
    private var motionManager = CMMotionManager()
    
    @Published var magneticStrength: Double = 0
    private var magneticField: CMMagneticField = CMMagneticField(x: 0, y: 0, z: 0)
    
    func start() {
        guard motionManager.isMagnetometerAvailable else {
            print("Magnetometer is not available on this device.")
            return
        }
        motionManager.showsDeviceMovementDisplay = true
        motionManager.magnetometerUpdateInterval = 0.5
        motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print("Magnetometer error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.magneticField = data.magneticField
                    self.calculateMagneticStrength()
                }
            }
        }
    }
    
    func stop() {
        motionManager.stopMagnetometerUpdates()
    }
    
    private func calculateMagneticStrength() {
        magneticStrength = sqrt(pow(magneticField.x, 2) + pow(magneticField.y, 2) + pow(magneticField.z, 2))
    }
}
