//
//  ScannerView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct ScannerView: View {
    enum ViewState {
        case wifi
        case bluetooth
        
        var title: String {
            switch self {
            case .wifi: "Wi-Fi Scanner"
            case .bluetooth: "Bluetooth Scanner"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .wifi: "SEARCH DEVICES ON SHARED WI-FI"
            case .bluetooth: "SEARCH FOR BLUETOOTH DEVICES"
            }
        }
    }
    
    @EnvironmentObject var iapViewModel: IAPViewModel
    @EnvironmentObject var tabManager: TabManager
    
    @ObservedObject private var viewModel = ScannerViewModel()
    
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var paywallViewState: PaywallView.ViewState = .info
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 4) {
                    Button(action: {
                        generateHapticFeedback()
                        tabManager.scannerViewState = .wifi
                        if viewModel.isBluetoothScanning {
                            viewModel.stopBluetoothScan()
                        }
                    }) {
                        HStack {
                            Image(.homeWifi)
                            Text("WI-FI")
                                .font(AppFont.button.font)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(tabManager.scannerViewState == .wifi ? .second : .third)
                        .foregroundStyle(tabManager.scannerViewState == .wifi ? .gray0 : .gray70)
                    }
                    Button(action: {
                        generateHapticFeedback()
                        tabManager.scannerViewState = .bluetooth
                        if viewModel.isLanScanning {
                            viewModel.stopLanScan()
                        }
                    }) {
                        HStack {
                            Image(.bluetooth)
                            Text("BLUETOOTH")
                                .font(AppFont.button.font)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(tabManager.scannerViewState == .bluetooth ? .second : .third)
                        .foregroundStyle(tabManager.scannerViewState == .bluetooth ? .gray0 : .gray70)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.vertical, 40)
                Spacer()
                RadarLoader(progress: $viewModel.scanProgress)
                Spacer()
                ZStack {
                    if viewModel.isLanScanning || viewModel.isBluetoothScanning {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Unknown devices detected: \(viewModel.connectedDevices.count)")
                                    .font(AppFont.text.font)
                                    .foregroundColor(.gray90)
                                if tabManager.scannerViewState == .wifi {
                                    Text("Your IP: \(viewModel.getIpAddress() ?? "unknown")")
                                        .font(AppFont.smallText.font)
                                        .foregroundColor(.gray70)
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    } else {
                        Button(action: {
                            generateHapticFeedback()
                            if iapViewModel.isSubscribed {
                                switch tabManager.scannerViewState {
                                case .wifi:
                                    viewModel.startLanScan()
                                case .bluetooth:
                                    viewModel.startBluetoothScan()
                                }
                            } else {
                                paywallViewState = .info
                                showPaywall = true
                            }
                        }) {
                            Text(tabManager.scannerViewState.buttonTitle)
                                .font(AppFont.button.font)
                                .foregroundColor(.gray10)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.primaryApp)
                                .cornerRadius(12)
                        }
                    }
                }
                .frame(height: 50)
            }
            .padding([.bottom, .horizontal], 32)
            .background(Color.forth.ignoresSafeArea())
            .onDisappear {
                if viewModel.isLanScanning {
                    viewModel.stopLanScan()
                }
                if viewModel.isBluetoothScanning {
                    viewModel.stopBluetoothScan()
                }
            }
            .navigationDestination(isPresented: $viewModel.isNavigatingToResults) {
                ResultView()
                    .environmentObject(DeviceManager(devices: viewModel.connectedDevices))
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(tabManager.scannerViewState.title)
                        .font(AppFont.h4.font)
                        .foregroundStyle(.primaryApp)
                }
                if !iapViewModel.isSubscribed {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            paywallViewState = .subscriptions
                            showPaywall = true
                        }) {
                            Image(.premium)
                                .foregroundStyle(.warning)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(.settings)
                            .foregroundStyle(.gray70)
                    }
                }
            }
            .onChange(of: iapViewModel.subscriptionEndDate) { newValue in
                if newValue > Date.now.timeIntervalSinceReferenceDate {
                    showPaywall = false
                }
            }
            .fullScreenCover(isPresented: $showPaywall, content: {
                PaywallView(viewState: $paywallViewState, showPaywall: $showPaywall)
            })
            .fullScreenCover(isPresented: $showSettings, content: {
                SettingsView()
            })
            .overlay {
                CustomAlertView(
                    isPresented: $viewModel.showAlert,
                    title: "Scanner requires permission",
                    message: "The app requires access to scan for nearby devices.",
                    primaryButtonText: "Settings",
                    primaryAction: { openAppSettings() }
                )
            }
        }
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    ScannerView()
        .environmentObject(IAPViewModel())
        .environmentObject(TabManager())
}
