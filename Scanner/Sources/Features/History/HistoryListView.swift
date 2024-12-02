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
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteItem(device: device)
                                } label: {
                                    Image(.trashBin)
                                }
                                .tint(.error)
                            }
                        }
                    }
                }
            }
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
}

#Preview {
    HistoryListView()
        .environmentObject(HistoryViewModel())
}
