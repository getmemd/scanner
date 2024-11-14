//
//  HistoryView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("History")
                    .font(AppFont.h4.font)
                    .foregroundStyle(.primaryApp)
                    .padding(.bottom)
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
                                        DeviceListView(devices: devices.filter { $0.isSecure })
                                        DeviceListView(devices: devices.filter { !$0.isSecure }, isSecure: false)
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
                                        DeviceListView(devices: devices.filter { $0.isSecure })
                                        DeviceListView(devices: devices.filter { !$0.isSecure }, isSecure: false)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .refreshable {
                        viewModel.loadHistory()
                    }
                }
            }
        }
        .background(Color.forth.ignoresSafeArea())
        .onAppear {
            viewModel.loadHistory()
        }
    }
}

#Preview {
    HistoryView()
}
