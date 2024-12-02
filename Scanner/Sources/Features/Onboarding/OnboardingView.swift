//
//  OnboardingView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 14.11.2024.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    @Environment(\.requestReview) var requestReview
    @State private var currentPage = 0
    private let pages: [OnboardingPageViewModel] = [
        .init(
            title: "Ensure that your network connection is secure.",
            description: "This is the ideal moment to identify and thoroughly assess any potential risks to ensure your digital security remains intact.",
            image: .onboarding1
        ),
        .init(
            title: "Scan devices using Bluetooth and Wi-Fi connections.",
            description: "Locate nearby Bluetooth devices and identify devices that are currently connected to your Wi-Fi network or a shared Wi-Fi network.",
            image: .onboarding2
        ),
        .init(
            title: "Protect your personal privacy from unwanted surveillance.",
            description: "Our application provides a comprehensive set of tools to effectively ensure your privacy and protect your personal information.",
            image: .onboarding3
        ),
        .init(
            title: "Convenient and accurate identification with filters.",
            description: "You can track lost items and pinpoint their exact distance from your current location. You'll never lose important things again.",
            image: .onboarding4
        ),
        .init(
            title: "Detection system that is based on your camera.",
            description: "Use your camera to thoroughly scan and analyze your environment, detecting other unwanted devices within the area.",
            image: .onboarding5
        )
    ]
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                OnboardingPageView(viewModel: page) {
                    withAnimation {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            requestReview()
                            hasSeenOnboarding = true
                        }
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    OnboardingView()
}
