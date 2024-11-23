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
    @ObservedObject private var viewModel = ScannerViewModel()
    @ObservedObject private var bluetoothService = BluetoothService()
    @State private var viewState: ViewState = .bluetooth
    @State private var showPaywall = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 4) {
                    Button(action: {
                        generateHapticFeedback()
                        viewState = .wifi
                        if bluetoothService.isScanning {
                            bluetoothService.stopScan()
                        }
                    }) {
                        HStack {
                            Image(.homeWifi)
                            Text("WI-FI")
                                .font(AppFont.button.font)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewState == .wifi ? .second : .third)
                        .foregroundStyle(viewState == .wifi ? .gray0 : .gray70)
                    }
                    Button(action: {
                        generateHapticFeedback()
                        viewState = .bluetooth
                        if viewModel.isScanning {
                            viewModel.stopScan()
                        }
                    }) {
                        HStack {
                            Image(.bluetooth)
                            Text("BLUETOOTH")
                                .font(AppFont.button.font)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewState == .bluetooth ? .second : .third)
                        .foregroundStyle(viewState == .bluetooth ? .gray0 : .gray70)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.vertical, 40)
                Spacer()
                if viewModel.isScanning || bluetoothService.isScanning {
                    RadarLoader()
                }
                if (viewState == .wifi && viewModel.isScanning) || (
                    viewState == .bluetooth && bluetoothService.isScanning
                ) {
                    Spacer()
                    HStack {
                        Text("Unknown devices detected: \(viewState == .wifi ? viewModel.connectedDevices.count : bluetoothService.discoveredDevices.count)")
                            .font(AppFont.text.font)
                            .foregroundColor(.gray90)
                        Spacer()
                    }
                    if viewState == .wifi {
                        VStack(alignment: .leading) {
                            Text("Your IP: \(viewModel.getIpAddress() ?? "unknown")")
                                .font(AppFont.smallText.font)
                                .foregroundColor(.gray70)
                            ProgressView("Searching", value: viewModel.scanProgress, total: 1.0)
                                .font(AppFont.smallText.font)
                                .foregroundColor(.primaryApp)
                                .padding(.top)
                        }
                    }
                    Spacer()
                } else {
                    Spacer()
                    Button(action: {
                        generateHapticFeedback()
                        if iapViewModel.isSubscribed {
                            switch viewState {
                            case .wifi:
                                viewModel.reload()
                            case .bluetooth:
                                bluetoothService.startScan()
                                navigateToResult()
                            }
                        } else {
                            showPaywall = true
                        }
                    }) {
                        Text(viewState.buttonTitle)
                            .font(AppFont.button.font)
                            .foregroundColor(.gray10)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.primaryApp)
                            .cornerRadius(12)
                    }
                }
            }
            .padding([.bottom, .horizontal], 32)
            .background(Color.forth.ignoresSafeArea())
            .onDisappear {
                bluetoothService.stopScan()
                viewModel.stopScan()
            }
            .navigationDestination(isPresented: $viewModel.isNavigatingToResults) {
                switch viewState {
                case .wifi:
                    ResultView<LanDeviceModel>()
                        .environmentObject(
                            DeviceManager<LanDeviceModel>(devices: viewModel.connectedDevices)
                        )
                case .bluetooth:
                    ResultView<BluetoothDeviceModel>()
                        .environmentObject(
                            DeviceManager<BluetoothDeviceModel>(devices: bluetoothService.discoveredDevices)
                        )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(viewState.title)
                        .font(AppFont.h4.font)
                        .foregroundStyle(.primaryApp)
                }
                if !iapViewModel.isSubscribed {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showPaywall = true
                        }) {
                            Image(.premium)
                                .foregroundStyle(.warning)
                        }
                    }
                }
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
    
    private func navigateToResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            bluetoothService.checkSecure()
            viewModel.isNavigatingToResults = true
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
}
