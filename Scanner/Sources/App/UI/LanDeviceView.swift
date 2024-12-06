//
//  LanDeviceView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 05.11.2024.
//

import SwiftUI

struct LanDeviceView: View {
    @State var device: Device
    
    var body: some View {
        HStack {
            Image(device.isSecure ? .checkSquare : .dangerSquare)
                .foregroundStyle(device.isSecure ? .success : .error)
            VStack(alignment: .leading) {
                Text(device.name ?? "Unknown")
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
                    .multilineTextAlignment(.leading)
                Text(device.ipAddress)
                    .font(AppFont.smallText.font)
                    .foregroundStyle(.gray60)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Image(.arrowRight)
                .foregroundStyle(.gray80)
        }
        .padding(16)
    }
}
