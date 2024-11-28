//
//  HistoryListView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 25.11.2024.
//

import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    @EnvironmentObject var tabManager: TabManager
    
    @State private var path: [Device] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(viewModel.groupedDevices.keys.sorted(), id: \.self) { dateKey in
                    Section(header: Text(dateKey)) {
                        ForEach(viewModel.groupedDevices[dateKey] ?? []) { device in
                            Button {
                                path = [device]
                            } label: {
                                HistoryDeviceView(device: device)
                                    .padding(4)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteItems(in: dateKey, at: indexSet)
                        }
                    }
                }
            }
            .refreshable {
                viewModel.loadHistory()
            }
            .navigationDestination(for: Device.self) { device in
                switch device.type {
                case .lan:
                    DetailLanView(lanDevice: device)
                case .bluetooth:
                    DetailBluetoothView(bleDevice: device)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    generateHapticFeedback()
                    viewModel.showAlert = true
                }) {
                    Image(.trashBin)
                        .foregroundStyle(.gray80)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .alert("Do you want to delete the history?", isPresented: $viewModel.showAlert) {
            Button("Delete History", role: .destructive) {
                viewModel.clearHistory()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("It can't be recovered once deleted.")
        }
    }
    
    
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    HistoryListView()
        .environmentObject(HistoryViewModel())
}
