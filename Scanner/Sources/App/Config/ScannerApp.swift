//
//  ScannerApp.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI
import RevenueCat
import AppsFlyerLib
import AppTrackingTransparency

@main
struct ScannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    Task {
                        let result = await ATTrackingManager.requestTrackingAuthorization()
                        switch result {
                        case .notDetermined:
                            break
                        case .restricted, .denied, .authorized:
                            timer.invalidate()
                        @unknown default:
                            break
                        }
                    }
                }
            }
            .task {
                let center = UNUserNotificationCenter.current()
                do {
                    try await center.requestAuthorization(options: [.alert, .sound, .badge])
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
