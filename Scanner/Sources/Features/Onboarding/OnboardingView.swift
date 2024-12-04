//
//  OnboardingView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 14.11.2024.
//

import SwiftUI

struct OnboardingView: View {
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
            }
            PaywallView(viewState: .constant(.info), showPaywall: $showPaywall)
                .tag(pages.count)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    OnboardingView()
        .environmentObject(IAPViewModel())
}
