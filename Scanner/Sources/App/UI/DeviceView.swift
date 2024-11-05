//
//  DeviceView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 05.11.2024.
//

import SwiftUI
import LanScanner

struct DeviceView: View {
    enum ViewState {
        case wifi
        case bluetooth
    }
    
    @State var viewState: ViewState = .wifi
    @State var lanDevice: LanDevice?
    @State var bluetoothDevice: BluetoothDevice?
    @State var isVerified = true
    
    var body: some View {
        HStack {
            Image(.dangerSquare)
                .foregroundStyle(.error)
            VStack(alignment: .leading) {
                Text((viewState == .wifi ? lanDevice?.name : bluetoothDevice?.peripheral.name) ?? "Unknown device")
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
                Text(
                    (
                        viewState == .wifi ? lanDevice?.ipAddress : bluetoothDevice?.peripheral.identifier.uuidString
                    ) ?? "Unknown address"
                )
                .font(AppFont.smallText.font)
                .foregroundStyle(.gray60)
            }
            Spacer()
            if viewState == .bluetooth {
                Text(calculateDistance())
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
            }
            Image(.arrowRight)
                .foregroundStyle(.gray80)
        }
    }
    
    private func calculateDistance() -> String {
        let measuredPower: Int = -59
        if let bluetoothDevice {
            return String(format: "%.2f m", pow(10.0, Double(measuredPower - bluetoothDevice.rssi.intValue) / 20.0))
        } else {
            return "Unknown distance"
        }
    }
}

#Preview {
    DeviceView()
}
