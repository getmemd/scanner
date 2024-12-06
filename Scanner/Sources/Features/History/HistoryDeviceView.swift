//
//  HistoryDeviceView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 25.11.2024.
//

import SwiftUI

struct HistoryDeviceView: View {
    var device: Device
    
    var body: some View {
        HStack {
            Image(device.type == .bluetooth ? .bluetooth : .homeWifi)
                .foregroundStyle(device.isSecure ? .success : .error)
            VStack(alignment: .leading) {
                Text(device.name ?? "Unknown")
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
                Text(device.type == .bluetooth ? device.id.uuidString : device.ipAddress)
                    .font(AppFont.smallText.font)
                    .foregroundStyle(.gray60)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Image(.arrowRight)
                .foregroundStyle(.gray80)
        }
        .padding([.top, .horizontal])
    }
}

#Preview {
    HistoryDeviceView(device: .init(id: .init(), name: "Device", rssi: 1))
}
