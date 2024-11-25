//
//  DetailBluetoothView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct DetailBluetoothView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var deviceManager: DeviceManager
    @State private var proximity = 0
    
    @State var bleDevice: Device
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(bleDevice.isSecure ? .checkSquare : .dangerSquare)
                        .foregroundColor(bleDevice.isSecure ? .success : .error)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(bleDevice.name ?? "Unknown")
                            .font(AppFont.text.font)
                            .foregroundColor(.gray80)
                        Text(bleDevice.id.uuidString)
                            .font(AppFont.smallText.font)
                            .foregroundColor(.gray60)
                    }
                    Spacer()
                }
                .padding(.bottom, 8)
                VStack(spacing: 0) {
                    Text("\(proximity) %")
                        .font(AppFont.custom(size: 64, weight: .semibold).font)
                        .foregroundStyle(.primaryApp)
                    CustomProgressView(value: Double(proximity) / 100, shape: Capsule())
                        .frame(height: 33.0)
                        .padding(.top, 8)
                        .padding([.horizontal, .bottom], 16)
                    Text("The percentage is an indication of the proximity of the device to the user.")
                        .font(AppFont.smallText.font)
                        .foregroundStyle(.gray70)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(bleDevice.isSecure ? .success : .error, lineWidth: 1)
            )
            Spacer()
            Button(action: {
                generateHapticFeedback()
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
                Text("LABEL THE DEVICE AS \(bleDevice.isSecure ? "UNSECURE" : "SAFE")")
                    .font(AppFont.button.font)
                    .foregroundColor(bleDevice.isSecure ? .error : .success)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(bleDevice.isSecure ? .error : .success, lineWidth: 2)
                    )
            }
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.forth.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
                            Image(.bluetooth)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray70)
                            Text("Bluetooth scanner")
                                .font(AppFont.smallText.font)
                                .foregroundColor(.gray70)
                        }
                    }
                }
            }
        }
        .onAppear {
            calculateProximityPercentage()
        }
    }
    
    private func calculateProximityPercentage() {
        guard let rssi = bleDevice.rssi else { return }
        let minRSSI = -100
        let maxRSSI = -40
        let clampedRSSI = max(min(rssi, maxRSSI), minRSSI)
        let proximityPercentage = (Double(clampedRSSI - minRSSI) / Double(maxRSSI - minRSSI)) * 100
        proximity = Int(proximityPercentage)
    }
    
    private func secureDevice() {
        StorageService.shared.updateDevice(id: bleDevice.id)
        bleDevice.isSecure.toggle()
        deviceManager.toggleSecureStatus(for: bleDevice)
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    DetailBluetoothView(bleDevice: .init(id: .init(), name: "AirPods", rssi: 0))
}
