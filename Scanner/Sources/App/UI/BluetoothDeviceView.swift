//
//  BluetoothDeviceView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct BluetoothDeviceView: View {
    @State var device: Device
    
    var body: some View {
        HStack {
            Image(device.isSecure ? .checkSquare : .dangerSquare)
                .foregroundStyle(device.isSecure ? .success : .error)
            VStack(alignment: .leading) {
                Text(device.name ?? "Unknown device")
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
                    .multilineTextAlignment(.leading)
                Text(device.id.uuidString)
                    .font(AppFont.smallText.font)
                    .foregroundStyle(.gray60)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Text(calculateDistance())
                .font(AppFont.text.font)
                .foregroundStyle(.gray80)
            Image(.arrowRight)
                .foregroundStyle(.gray80)
        }
        .padding(16)
    }
    
    private func calculateDistance() -> String {
        guard let rssi = device.rssi else { return "" }
        return String(format: "%.2f m", pow(10.0, Double(-59 - rssi) / (10 * 2)))
    }
}

#Preview {
    BluetoothDeviceView(device: .init(id: .init(), name: nil, rssi: 0))
}
