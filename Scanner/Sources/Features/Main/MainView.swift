//
//  MainView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var iapViewModel: IAPViewModel
    @State private var selection: Int = 2
    
    var body: some View {
        TabView(selection:$selection) {
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
            SettingsView()
                .tabItem {
                    Image(.settings)
                    Text("Settings")
                }
                .tag(4)
        }
    }
}

#Preview {
    MainView()
}
