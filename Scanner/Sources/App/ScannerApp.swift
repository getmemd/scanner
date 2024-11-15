//
//  ScannerApp.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

@main
struct ScannerApp: App {
    @State private var isOnboardingActive: Bool
    
    init() {
        _isOnboardingActive = State(initialValue: !StorageService.shared.isOnboardingShowed())
    }
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingActive {
                OnboardingView(isOnboardingActive: $isOnboardingActive)
                    .ignoresSafeArea()
            } else {
                MainView()
            }
        }
    }
}
