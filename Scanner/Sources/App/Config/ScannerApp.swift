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
    @State private var isOnboardingActive: Bool
    @State private var isSplashActive: Bool = true
    @State private var showPaywall = false
    
    @StateObject private var iapViewModel = IAPViewModel()
    
    init() {
        _isOnboardingActive = State(initialValue: !StorageService.shared.isOnboardingShowed())
        Purchases.configure(withAPIKey: AppConstants.revenueCatKey)
        Purchases.logLevel = .verbose
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isSplashActive {
                    SplashscreenView()
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isSplashActive = false
                                }
                            }
                        }
                } else if isOnboardingActive {
                    OnboardingView(isOnboardingActive: $isOnboardingActive)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: isOnboardingActive)
                } else {
                    MainView()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: isOnboardingActive)
                }
            }
            .fullScreenCover(isPresented: $showPaywall, content: {
                PaywallView()
            })
            .environmentObject(iapViewModel)
            .onChange(of: iapViewModel.subscriptionEndDate) { newValue in
                if newValue > Date.now.timeIntervalSinceReferenceDate {
                    showPaywall = false
                }
            }
        }
    }
}
