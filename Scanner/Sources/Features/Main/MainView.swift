//
//  MainView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HistoryView()
                .tabItem {
                    Image(.history)
                    Text("History")
                }
            MagnetView()
                .tabItem {
                    Image(.magnetWave)
                    Text("Magnet")
                }
            ScannerView()
                .tabItem {
                    Image(.roundGraph)
                    Text("Radar")
                }
            CameraView()
                .tabItem {
                    Image(.eyeScan)
                    Text("Detector")
                }
            SettingsView()
                .tabItem {
                    Image(.settings)
                    Text("Settings")
                }
        }
    }
}

#Preview {
    MainView()
}
