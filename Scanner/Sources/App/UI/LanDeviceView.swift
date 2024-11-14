//
//  LanDeviceView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 05.11.2024.
//

import SwiftUI

struct LanDeviceView: View {
    @State var selectedDevice: Device<LanDeviceModel>
    
    var body: some View {
        HStack {
            Image(selectedDevice.isSecure ? .checkSquare : .dangerSquare)
                .foregroundStyle(selectedDevice.isSecure ? .success : .error)
            VStack(alignment: .leading) {
                Text(selectedDevice.device.name)
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
                Text(selectedDevice.device.ipAddress)
                    .font(AppFont.smallText.font)
                    .foregroundStyle(.gray60)
            }
            Spacer()
            Image(.arrowRight)
                .foregroundStyle(.gray80)
        }
    }
}
