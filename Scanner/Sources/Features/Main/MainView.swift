//
//  MainView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct MainView: View {
    @State private var showPaywall = false
    @State private var paywallViewState: PaywallView.ViewState = .info
    @StateObject private var tabManager = TabManager()
    @StateObject private var iapViewModel = IAPViewModel()
    
    var body: some View {
        TabView(selection: $tabManager.selectedTab) {
            HistoryView()
                .tabItem {
                    Image(.history)
                    Text("History")
                }
                .tag(0)
            MagnetView()
                .tabItem {
                    Image(.magnetWave)
                    Text("Magnet")
                }
                .tag(1)
            ScannerView()
                .tabItem {
                    Image(.roundGraph)
                    Text("Radar")
                }
                .tag(2)
            CameraView()
                .tabItem {
                    Image(.eyeScan)
                    Text("Detector")
                }
                .tag(3)
        }
        .fullScreenCover(isPresented: $showPaywall, content: {
            PaywallView(viewState: $paywallViewState, showPaywall: $showPaywall)
        })
        .environmentObject(tabManager)
        .environmentObject(iapViewModel)
        .onChange(of: iapViewModel.subscriptionEndDate) { newValue in
            if newValue > Date.now.timeIntervalSinceReferenceDate {
                showPaywall = false
            }
        }
        .onAppear {
            withAnimation {
                if !iapViewModel.isSubscribed {
                    showPaywall = true
                }
            }
        }
    }
}

#Preview {
    MainView()
}
