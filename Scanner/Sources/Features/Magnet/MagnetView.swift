//
//  MagnetView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 03.11.2024.
//

import SwiftUI

struct MagnetView: View {
    @EnvironmentObject var iapViewModel: IAPViewModel
    
    @State private var showPaywall = false
    @State private var isScanning: Bool = false {
        didSet {
            isScanning ? magnetometorService.start() : magnetometorService.stop()
        }
    }
    
    @StateObject private var magnetometorService = MagnetometorService()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 0) {
                    Text("Find electromagnetic signals from electronic devices.")
                        .font(AppFont.text.font)
                        .foregroundStyle(.gray80)
                        .padding(.top, 24)
                    HStack {
                        Text("\(String(format: "%.1f", isScanning ? magnetometorService.magneticStrength : 0))")
                            .font(AppFont.custom(size: 64, weight: .semibold).font)
                            .foregroundStyle(.primaryApp)
                        Text("µT")
                            .font(AppFont.custom(size: 32, weight: .regular).font)
                            .foregroundStyle(.primaryApp)
                    }
                    .padding(.top, 32)
                    CustomProgressView(value: isScanning ? magnetometorService.magneticStrength / 300 : 0, shape: Capsule())
                        .frame(height: 33.0)
                        .padding(.top, 8)
                        .padding([.horizontal, .bottom], 16)
                    HStack {
                        Text("0")
                            .font(AppFont.smallText.font)
                            .foregroundStyle(.gray70)
                        Spacer()
                        Text("300")
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
                    generateHapticFeedback()
                    if iapViewModel.isSubscribed {
                        isScanning.toggle()
                    } else {
                        showPaywall = true
                    }
                }) {
                    Text(isScanning ? "STOP SCANNING" : "START SCANNING")
                        .font(AppFont.button.font)
                        .foregroundColor(.gray10)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.primaryApp)
                        .cornerRadius(12)
                }
            }
            .padding([.bottom, .horizontal], 32)
            .background(Color.forth.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("Magnetic Detector")
                        .font(AppFont.h4.font)
                        .foregroundStyle(.primaryApp)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showPaywall = true
                    }) {
                        Image(.premium)
                            .foregroundStyle(.warning)
                    }
                }
            }
            .onDisappear {
                magnetometorService.stop()
                isScanning = false
            }
            .onChange(of: iapViewModel.subscriptionEndDate) { newValue in
                if newValue > Date.now.timeIntervalSinceReferenceDate {
                    showPaywall = false
                }
            }
            .fullScreenCover(isPresented: $showPaywall, content: {
                PaywallView(showPaywall: $showPaywall)
            })
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    MagnetView()
        .environmentObject(IAPViewModel())
}
