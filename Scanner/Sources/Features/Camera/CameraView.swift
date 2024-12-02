//
//  CameraView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var iapViewModel: IAPViewModel
    
    @StateObject private var model = CameraDataModel()
    @State private var selectedFilter = FilterType.red
    @State private var paywallViewState: PaywallView.ViewState = .info
    @State private var showPaywall = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                GeometryReader { geometry in
                    if let image = model.viewfinderImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .border(Color.black, width: 1)
                            .cornerRadius(16)
                    } else {
                        RadarLoader(progress: .constant(1))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .padding()
                Spacer()
                if model.viewfinderImage == nil {
                    Button(action: {
                        generateHapticFeedback()
                        if iapViewModel.isSubscribed {
                            Task {
                                do {
                                    try await model.camera.start()
                                } catch {
                                    showAlertWith(message: error.localizedDescription)
                                }
                            }
                            
                        } else {
                            paywallViewState = .info
                            showPaywall = true
                        }
                    }) {
                        Text("SEARCH VIA CAMERA DETECTOR")
                            .font(AppFont.button.font)
                            .foregroundColor(.gray10)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.primaryApp)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                }
                HStack(spacing: 32) {
                    ForEach(FilterType.allCases, id: \.self) { filter in
                        Button(action: {
                            generateHapticFeedback()
                            model.camera.setFilter(filter)
                            selectedFilter = filter
                        }) {
                            switch filter {
                            case .red:
                                Image(selectedFilter == filter ? .redSelected : .red)
                            case .green:
                                Image(selectedFilter == filter ? .greenSelected : .green)
                            case .blue:
                                Image(selectedFilter == filter ? .blueSelected : .blue)
                            case .blackWhite:
                                Image(selectedFilter == filter ? .bwSelected : .bw)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .background(Color.forth.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("Camera Detector")
                        .font(AppFont.h4.font)
                        .foregroundStyle(Color.primaryApp)
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
            }
            .onDisappear {
                model.camera.stop()
                model.viewfinderImage = nil
            }
            .onChange(of: iapViewModel.subscriptionEndDate) { newValue in
                if newValue > Date.now.timeIntervalSinceReferenceDate {
                    showPaywall = false
                }
            }
            .fullScreenCover(isPresented: $showPaywall, content: {
                PaywallView(viewState: $paywallViewState, showPaywall: $showPaywall)
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Camera Access Required"),
                    message: Text(alertMessage),
                    primaryButton: .default(Text("Settings")) {
                        openAppSettings()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
    }
    
    private func showAlertWith(message: String) {
        alertMessage = message
        showAlert = true
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
    CameraView()
        .environmentObject(IAPViewModel())
}
