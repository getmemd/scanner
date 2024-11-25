//
//  HistoryListView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 25.11.2024.
//

import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.groupedDevices.keys.sorted(), id: \.self) { dateKey in
                Section(header: Text(dateKey)) {
                    ForEach(viewModel.groupedDevices[dateKey] ?? []) { device in
                            Button {
                                
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
        }
        .toolbar {
            EditButton()
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
