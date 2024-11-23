//
//  OnboardingPageView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 15.11.2024.
//

import SwiftUI

struct OnboardingPageView: View {
    let viewModel: OnboardingPageViewModel
    let onNext: (() -> Void)
    
    @State private var isBouncing = false
    
    var body: some View {
        VStack {
            Image(viewModel.image)
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(AppFont.h4.font)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 8)
                Text(viewModel.description)
                    .font(AppFont.text.font)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 32)
                Button(action: {
                    generateHapticFeedback()
                    onNext()
                }) {
                    Text("CONTINUE")
                        .font(AppFont.button.font)
                        .foregroundColor(.gray10)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.primaryApp)
                        .cornerRadius(12)
                }
                .padding(.bottom)
            }
        }
        .padding()
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    OnboardingPageView(viewModel: .init(title: "Ensure that your network connection is secure.",
                                        description: "This is the ideal moment to identify and thoroughly assess any potential risks to ensure your digital security remains intact.",
                                        image: .onboarding1),
                                        onNext: { })
}
