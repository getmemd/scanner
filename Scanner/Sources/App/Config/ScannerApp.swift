//
//  ScannerApp.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI
import RevenueCat

@main
struct ScannerApp: App {
    @State private var isSplashActive: Bool = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    init() {
        Purchases.configure(withAPIKey: AppConstants.revenueCatKey)
        Purchases.logLevel = .verbose
    }
    
    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                SplashscreenView()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isSplashActive = false
                        }
                    }
            } else if !hasSeenOnboarding {
                OnboardingView()
                    .ignoresSafeArea()
            } else {
                MainView()
            }
        }
    }
}
