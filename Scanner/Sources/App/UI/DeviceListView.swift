//
//  DeviceListView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct DeviceListView<T: Codable>: View {
    var devices: [Device<T>]
    var isSecure = true
    
    var body: some View {
        VStack {
            ForEach(devices) { device in
                VStack {
                    if let lanDevice = device as? Device<LanDeviceModel> {
                        NavigationLink(destination: DetailLanView(lanDevice: lanDevice.device, isSecure: isSecure)) {
                            LanDeviceView(selectedDevice: lanDevice)
                        }
                    } else if let bluetoothDevice = device as? Device<BluetoothDeviceModel> {
                        NavigationLink(
                            destination: DetailBluetoothView(
                                bluetoothDevice: bluetoothDevice.device,
                                isSecure: isSecure
                            )
                        ) {
                            BluetoothDeviceView(selectedDevice: bluetoothDevice)
                        }
                    }
                    Divider()
                }
                .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSecure ? .success : .error, lineWidth: 1)
        )
    }
}
