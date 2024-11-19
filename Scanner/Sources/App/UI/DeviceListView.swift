//
//  DeviceListView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct DeviceListView<T: Codable>: View {
    @EnvironmentObject var deviceManager: DeviceManager<T>

    var body: some View {
        VStack {
            deviceSection(isSecure: true)
            deviceSection(isSecure: false)
        }
    }

    @ViewBuilder
    private func deviceSection(isSecure: Bool) -> some View {
        VStack {
            ForEach(deviceManager.devicesFiltered(by: isSecure)) { device in
                VStack {
                    deviceRow(for: device)
                    Divider()
                }
                .padding()
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSecure ? .success : .error, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func deviceRow(for device: Device<T>) -> some View {
        if let lanDevice = device as? Device<LanDeviceModel> {
            NavigationLink(
                destination: DetailLanView(lanDevice: lanDevice)
                    .environmentObject(deviceManager)
            ) {
                LanDeviceView(selectedDevice: lanDevice)
            }
        } else if let bluetoothDevice = device as? Device<BluetoothDeviceModel> {
            NavigationLink(
                destination: DetailBluetoothView(bleDevice: bluetoothDevice)
                    .environmentObject(deviceManager)
            ) {
                BluetoothDeviceView(selectedDevice: bluetoothDevice)
            }
        }
    }
}
