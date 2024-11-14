//
//  BluetoothDeviceView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct BluetoothDeviceView: View {
    @State var selectedDevice: Device<BluetoothDeviceModel>
    
    var body: some View {
        HStack {
            Image(selectedDevice.isSecure ? .checkSquare : .dangerSquare)
                .foregroundStyle(selectedDevice.isSecure ? .success : .error)
            VStack(alignment: .leading) {
                Text(selectedDevice.device.name ?? "Unknown device")
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
                Text(selectedDevice.device.id.uuidString)
                    .font(AppFont.smallText.font)
                    .foregroundStyle(.gray60)
            }
            Spacer()
            Text(calculateDistance())
                .font(AppFont.text.font)
                .foregroundStyle(.gray80)
            Image(.arrowRight)
                .foregroundStyle(.gray80)
        }
    }
    
    private func calculateDistance() -> String {
        guard let rssi = selectedDevice.device.rssi else { return "" }
        return String(format: "%.2f m", pow(10.0, Double(-59 - rssi) / (10 * 2)))
    }
}
