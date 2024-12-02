//
//  HistoryView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.devices.isEmpty {
                    HistoryEmptyView()
                } else {
                    HistoryListView()
                        .environmentObject(viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("History")
                        .font(AppFont.h4.font)
                        .foregroundStyle(.primaryApp)
                        .padding(.bottom)
                }
                if !viewModel.devices.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            generateHapticFeedback()
                            viewModel.showAlert = true
                        }) {
                            Image(.trashBin)
                                .foregroundStyle(.gray80)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(.settings)
                            .foregroundStyle(.gray70)
                    }
                }
            }
        }
        .background(Color.forth.ignoresSafeArea())
        .fullScreenCover(isPresented: $showSettings, content: {
            SettingsView()
        })
        .overlay {
            CustomAlertView(
                isPresented: $viewModel.showAlert,
                title: "Do you want to delete the history?",
                message: "It can't be recovered once deleted.",
                primaryButtonText: "Delete history",
                primaryAction: { viewModel.clearHistory() }
            )
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    HistoryView()
}
