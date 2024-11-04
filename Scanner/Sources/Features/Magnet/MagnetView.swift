//
//  MagnetView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 03.11.2024.
//

import SwiftUI

struct MagnetView: View {
    @State private var isScanning: Bool = false {
        didSet {
            isScanning ? magnetometorService.start() : magnetometorService.stop()
        }
    }
    @State private var progress: Double = 0.5
    
    @StateObject private var magnetometorService = MagnetometorService()
    
    var body: some View {
        VStack {
            HStack {
                Text("Magnetic Detector")
                    .font(AppFont.h4.font)
                    .foregroundStyle(.primaryApp)
                Spacer()
            }
            VStack(spacing: 0) {
                Text("Find electromagnetic signals from electronic devices.")
                    .font(AppFont.text.font)
                    .foregroundStyle(.gray80)
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                HStack {
                    Text("\(String(format: "%.1f", magnetometorService.magneticStrength))%")
                        .font(AppFont.custom(size: 64, weight: .semibold).font)
                        .foregroundStyle(.primaryApp)
                    Text("µT")
                        .font(AppFont.custom(size: 32, weight: .regular).font)
                        .foregroundStyle(.primaryApp)
                }
                .padding(.top, 32)
                CustomProgressView(value: magnetometorService.magneticStrength / 1500, shape: Capsule())
                    .frame(height: 33.0)
                    .padding(.top, 8)
                    .padding([.horizontal, .bottom], 16)
                HStack {
                    Text("0")
                        .font(AppFont.smallText.font)
                        .foregroundStyle(.gray70)
                    Spacer()
                    Text("1500")
                        .font(AppFont.smallText.font)
                        .foregroundStyle(.gray70)
                }
                .padding(.bottom, 24)
                .padding(.horizontal, 16)
            }
            .background(.gray0)
            .clipShape(.rect(cornerRadius: 16))
            .padding(.top, 40)
            Spacer()
            Button(action: {
                isScanning.toggle()
            }) {
                Text(isScanning ? "STOP SCANNING" : "START SCANNING")
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 16)
        }
        .padding([.bottom, .horizontal], 32)
        .background(Color.forth.ignoresSafeArea())
        .onDisappear {
            magnetometorService.stop()
            isScanning = false
        }
    }
}

#Preview {
    MagnetView()
}
