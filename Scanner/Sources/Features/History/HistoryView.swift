//
//  HistoryView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.bleDevicesByDate.isEmpty && viewModel.lanDevicesByDate.isEmpty {
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
                            // Действие для перехода к сканированию Wi-Fi
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
                            // Действие для перехода к сканированию Bluetooth
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
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.sortedLanDates, id: \.self) { date in
                                if let devices = viewModel.lanDevicesByDate[date], !devices.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 4) {
                                            Image(.homeWifi)
                                                .resizable()
                                                .foregroundStyle(.gray70)
                                                .frame(width: 16, height: 16)
                                            Text("Wi-Fi")
                                                .font(AppFont.smallText.font)
                                                .foregroundStyle(.gray70)
                                        }
                                        Text(date.formatted(date: .long, time: .omitted))
                                            .font(AppFont.h5.font)
                                            .foregroundStyle(.gray90)
                                        DeviceListView<LanDeviceModel>()
                                            .environmentObject(DeviceManager<LanDeviceModel>(devices: devices))
                                    }
                                }
                            }
                            ForEach(viewModel.sortedBleDates, id: \.self) { date in
                                if let devices = viewModel.bleDevicesByDate[date], !devices.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 4) {
                                            Image(.bluetooth)
                                                .resizable()
                                                .foregroundStyle(.gray70)
                                                .frame(width: 16, height: 16)
                                            Text("Bluetooth")
                                                .font(AppFont.smallText.font)
                                                .foregroundStyle(.gray70)
                                        }
                                        Text(date.formatted(date: .long, time: .omitted))
                                            .font(AppFont.h5.font)
                                            .foregroundStyle(.gray90)
                                        DeviceListView<BluetoothDeviceModel>()
                                            .environmentObject(DeviceManager<BluetoothDeviceModel>(devices: devices))
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .refreshable {
                        viewModel.loadHistory()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                generateHapticFeedback()
                                showAlert = true
                            }) {
                                Image(.trashBin)
                                    .foregroundStyle(.gray80)
                            }
                        }
                    }
                    .alert("Do you want to delete the history?", isPresented: $showAlert) {
                        Button("Delete History", role: .destructive) {
                            viewModel.clearHistory()
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("It can't be recovered once deleted.")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("History")
                        .font(AppFont.h4.font)
                        .foregroundStyle(.primaryApp)
                        .padding(.bottom)
                }
            }
        }
        .background(Color.forth.ignoresSafeArea())
        .onAppear {
            viewModel.loadHistory()
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
