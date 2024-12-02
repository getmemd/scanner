//
//  ResultView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var deviceManager: DeviceManager
    
    var body: some View {
        NavigationStack {
            if deviceManager.devices.isEmpty {
                VStack {
                    Spacer()
                    Image(.splashscreen)
                        .opacity(0.5)
                    Spacer()
                    VStack(spacing: 0) {
                        Text("No devices detected")
                            .font(AppFont.h5.font)
                            .foregroundColor(.gray100)
                        Text("Please, try again")
                            .font(AppFont.text.font)
                            .foregroundColor(.gray70)
                    }
                    Button(action: {
                        generateHapticFeedback()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("SEARCH")
                            .font(AppFont.button.font)
                            .foregroundColor(.gray10)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.primaryApp)
                            .cornerRadius(12)
                    }
                }
                .padding()
            } else {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Found devices: \(deviceManager.devices.count)")
                                .font(AppFont.h5.font)
                                .foregroundColor(.gray90)
                            Spacer()
                            Text("Dubious devices: \(deviceManager.devicesFiltered(by: false).count)")
                                .font(AppFont.h5.font)
                                .foregroundColor(.error)
                        }
                        VStack {
                            deviceSection(isSecure: false)
                            deviceSection(isSecure: true)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.forth.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(.arrowLeft)
                            .foregroundColor(.gray90)
                        Text("Result")
                            .font(AppFont.h4.font)
                            .foregroundColor(.primaryApp)
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    private func deviceSection(isSecure: Bool) -> some View {
        VStack {
            ForEach(deviceManager.devicesFiltered(by: isSecure)) { device in
                VStack {
                    deviceRow(for: device)
                    Divider()
                        .foregroundStyle(.third)
                        .padding(.horizontal)
                }
            }
        }
        .background(.gray0)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSecure ? .success : .error, lineWidth: 1)
        }
    }
    
    @ViewBuilder
    private func deviceRow(for device: Device) -> some View {
        switch device.type {
        case .bluetooth:
            NavigationLink(
                destination: DetailBluetoothView(bleDevice: device)
                    .environmentObject(deviceManager)
            ) {
                BluetoothDeviceView(device: device)
            }
        case .lan:
            NavigationLink(
                destination: DetailLanView(lanDevice: device)
                    .environmentObject(deviceManager)
            ) {
                LanDeviceView(device: device)
            }
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    ResultView()
        .environmentObject(DeviceManager(devices: [
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: nil, rssi: 10),
//            .init(id: UUID(), name: "Some device", rssi: 100)
        ]))
}
