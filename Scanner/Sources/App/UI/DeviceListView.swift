//
//  DeviceListView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct DeviceListView<T: Codable>: View {
    var devices: [Device<T>]
    @State var isSecure: Bool = true
    
    var body: some View {
        VStack {
            ForEach(devices) { device in
                VStack {
                    if let lanDevice = device as? Device<LanDeviceModel> {
                        NavigationLink(destination: DetailLanView(
                            isSecure: isSecure,
                            lanDevice: lanDevice.device)) {
                                LanDeviceView(selectedDevice: lanDevice)
                            }
                    } else if let bluetoothDevice = device as? Device<BluetoothDeviceModel> {
                        NavigationLink(destination: DetailBluetoothView(
                            isSecure: isSecure,
                            bluetoothDevice: bluetoothDevice.device)) {
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
