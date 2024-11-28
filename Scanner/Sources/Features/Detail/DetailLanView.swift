//
//  DetailLanView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct DetailLanView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var deviceManager: DeviceManager
    @EnvironmentObject var tabManager: TabManager
    
    @State var lanDevice: Device
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(lanDevice.isSecure ? .checkSquare : .dangerSquare)
                        .foregroundColor(lanDevice.isSecure ? .success : .error)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(lanDevice.name ?? "Unknown")
                            .font(AppFont.text.font)
                            .foregroundColor(.gray80)
                        Text(lanDevice.ipAddress)
                            .font(AppFont.smallText.font)
                            .foregroundColor(.gray60)
                    }
                    Spacer()
                }
                .padding(.bottom, 8)
                Divider()
                HStack {
                    Text("IP Address")
                        .font(AppFont.text.font)
                        .foregroundColor(.gray80)
                    Spacer()
                    Text(lanDevice.ipAddress)
                        .font(AppFont.smallText.font)
                        .foregroundColor(.gray60)
                }
                Divider()
                HStack {
                    Text("Mac Address")
                        .font(AppFont.text.font)
                        .foregroundColor(.gray80)
                    Spacer()
                    Text(lanDevice.mac ?? "Unknown")
                        .font(AppFont.smallText.font)
                        .foregroundColor(.gray60)
                }
                Divider()
                HStack {
                    Text("Hostname")
                        .font(AppFont.text.font)
                        .foregroundColor(.gray80)
                    Spacer()
                    Text(lanDevice.brand)
                        .font(AppFont.smallText.font)
                        .foregroundColor(.gray60)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lanDevice.isSecure ? .success : .error, lineWidth: 1)
            )
            Spacer()
            Button(action: {
                generateHapticFeedback()
                tabManager.selectedTab = 1
            }) {
                Text("SEARCH")
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
            Button(action: {
                generateHapticFeedback()
                secureDevice()
            }) {
                Text("LABEL THE DEVICE AS \(lanDevice.isSecure ? "UNSECURE" : "SAFE")")
                    .font(AppFont.button.font)
                    .foregroundColor(lanDevice.isSecure ? .error : .success)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lanDevice.isSecure ? .error : .success, lineWidth: 2)
                    )
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 8) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(.arrowLeft)
                            .foregroundColor(.gray90)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Device details")
                            .font(AppFont.h4.font)
                            .foregroundColor(.primaryApp)
                        HStack(spacing: 4) {
                            Image(.homeWifi)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray70)
                            Text("Wi-Fi scanner")
                                .font(AppFont.smallText.font)
                                .foregroundColor(.gray70)
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.forth.ignoresSafeArea())
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func secureDevice() {
        StorageService.shared.updateDevice(id: lanDevice.id)
        lanDevice.isSecure.toggle()
        deviceManager.toggleSecureStatus(for: lanDevice)
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
