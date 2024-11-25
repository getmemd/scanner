//
//  HistoryEmptyView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 25.11.2024.
//

import SwiftUI

struct HistoryEmptyView: View {
    @EnvironmentObject private var tabManager: TabManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("You have no search history yet")
                .font(AppFont.h5.font)
                .foregroundColor(.gray90)
            Text("Start using the app to have a check history.")
                .font(AppFont.text.font)
                .foregroundColor(.gray80)
        }
        Spacer()
        VStack {
            Button(action: {
                generateHapticFeedback()
                tabManager.selectedTab = 2
                tabManager.scannerViewState = .wifi
            }) {
                Text("SEARCH DEVICES ON SHARED WI-FI")
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
            Button(action: {
                generateHapticFeedback()
                tabManager.selectedTab = 2
                tabManager.scannerViewState = .bluetooth
            }) {
                Text("SEARCH FOR BLUETOOTH DEVICES")
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
        }
        .padding([.bottom, .horizontal], 32)
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    HistoryEmptyView()
        .environmentObject(TabManager())
}
