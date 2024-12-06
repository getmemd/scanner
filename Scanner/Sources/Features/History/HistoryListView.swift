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
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.groupedDevices.keys.sorted(), id: \.self) { dateKey in
                        Text(dateKey)
                        VStack(spacing: 8) {
                            deviceSection(dateKey: dateKey, isSecure: false)
                            deviceSection(dateKey: dateKey, isSecure: true)
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
            .background(Color.forth.ignoresSafeArea())
            .refreshable {
                viewModel.loadHistory()
            }
            .task {
                viewModel.loadHistory()
            }
            .navigationDestination(for: Device.self) { device in
                switch device.type {
                case .lan:
                    DetailLanView(lanDevice: device)
                        .environmentObject(DeviceManager(devices: viewModel.devices))
                case .bluetooth:
                    DetailBluetoothView(bleDevice: device)
                        .environmentObject(DeviceManager(devices: viewModel.devices))
                }
            }
        }
    }
    
    @ViewBuilder
    private func deviceSection(dateKey: String, isSecure: Bool) -> some View {
        VStack {
            ForEach(viewModel.groupedDevices[dateKey]?.filter({ $0.isSecure == isSecure }) ?? []) { device in
                VStack {
                    Button {
                        path = [device]
                    } label: {
                        SwipeableRow {
                            HistoryDeviceView(device: device)
                        } onDelete: {
                            viewModel.deleteItem(device: device)
                        }
                    }
                    Divider()
                        .background(.third)
                        .padding(.horizontal)
                }
            }
        }
        .background(.gray0)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSecure ? .success : .error, lineWidth: 1)
        }
    }
}
