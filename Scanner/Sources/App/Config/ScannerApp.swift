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
    @State private var isSplashActive = true
    @State private var showPaywall = false
    @StateObject private var iapViewModel = IAPViewModel()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    init() {
        Purchases.configure(withAPIKey: AppConstants.revenueCatKey)
        Purchases.logLevel = .verbose
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashActive {
                    SplashscreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isSplashActive = false
                            }
                        }
                } else if !hasSeenOnboarding {
                    OnboardingView()
                } else if showPaywall {
                    PaywallView(viewState: .constant(.info), showPaywall: $showPaywall)
                } else {
                    MainView()
                }
            }
            .environmentObject(iapViewModel)
            .onAppear {
                if !iapViewModel.isSubscribed && hasSeenOnboarding {
                    showPaywall = true
                }
            }
        }
    }
}
