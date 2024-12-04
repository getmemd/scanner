//
//  MainView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var tabManager = TabManager()
    
    @EnvironmentObject private var iapViewModel: IAPViewModel
    
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
        .environmentObject(tabManager)
    }
}

#Preview {
    MainView()
}
