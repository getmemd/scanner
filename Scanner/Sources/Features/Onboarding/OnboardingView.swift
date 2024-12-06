//
//  OnboardingView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 14.11.2024.
//

import SwiftUI
import AppTrackingTransparency

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @EnvironmentObject var iapViewModel: IAPViewModel
    @Environment(\.requestReview) var requestReview
    @State private var showPaywall = false
    @State private var currentPage = 0
    private let pages: [OnboardingPageViewModel] = [
        .init(
            title: "Ensure that your network\nconnection is secure.",
            description: "This is the ideal moment to identify and\nthoroughly assess any potential risks to\nensure your digital security remains intact.",
            image: .onboarding1
        ),
        .init(
            title: "Scan devices using Bluetooth\nand Wi-Fi connections.",
            description: "Locate nearby Bluetooth devices and identify\ndevices that are currently connected to your\nWi-Fi network or a shared Wi-Fi network.",
            image: .onboarding2
        ),
        .init(
            title: "Protect your personal privacy\nfrom unwanted surveillance.",
            description: "Our application provides a comprehensive set\nof tools to effectively ensure your privacy\nand protect your personal information.",
            image: .onboarding3
        ),
        .init(
            title: "Convenient and accurate\nidentification with filters.",
            description: "You can track lost items and pinpoint their\nexact distance from your current location.\nYou'll never lose important things again.",
            image: .onboarding4
        ),
        .init(
            title: "Detection system that is\nbased on your camera.",
            description: "Use your camera to thoroughly scan and\nanalyze your environment, detecting other\nunwanted devices within the area.",
            image: .onboarding5
        )
    ]
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                OnboardingPageView(viewModel: page) {
                    withAnimation {
                        if currentPage < pages.count {
                            currentPage += 1
                        }
                        if currentPage == 2 {
                            requestReview()
                        }
                    }
                }
                .tag(index)
                .gesture(DragGesture())
            }
            PaywallView(viewState: .constant(.info), showPaywall: $showPaywall)
                .tag(pages.count)
                .gesture(DragGesture())
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: iapViewModel.subscriptionEndDate) { newValue in
            if newValue > Date.now.timeIntervalSinceReferenceDate {
                showPaywall = false
                hasSeenOnboarding = true
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                Task {
                    let result = await ATTrackingManager.requestTrackingAuthorization()
                    switch result {
                    case .notDetermined:
                        break
                    case .restricted, .denied, .authorized:
                        timer.invalidate()
                    @unknown default:
                        break
                    }
                }
            }
        }
        .task {
            let center = UNUserNotificationCenter.current()
            do {
                try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(IAPViewModel())
}
