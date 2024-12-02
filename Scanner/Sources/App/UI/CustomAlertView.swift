//
//  CustomAlertView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 03.12.2024.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool

    var title: String
    var message: String?
    var primaryButtonText: String
    var primaryAction: () -> Void

    var body: some View {
        ZStack {
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    VStack {
                        Text(title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                        
                        if let message = message {
                            Text(message)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding([.top, .horizontal])
                    HStack(spacing: 0) {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Cancel")
                                .font(AppFont.button.font)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundStyle(.gray80)
                        }
                        .overlay(
                            Rectangle()
                                .stroke(.gray90, lineWidth: 0.5)
                        )
                        Button(action: {
                            isPresented = false
                            primaryAction()
                        }) {
                            Text(primaryButtonText)
                                .font(AppFont.button.font)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundStyle(.gray80)
                        }
                        .overlay(
                            Rectangle()
                                .stroke(.gray90, lineWidth: 0.5)
                        )
                    }
                }
                .background(.gray0)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    CustomAlertView(
        isPresented: .constant(true),
        title: "Allow Bluetooth Access",
        message: "The app needs Bluetooth access to scan for nearby devices.",
        primaryButtonText: "ALLOW",
        primaryAction: {
            print("Allow tapped")
        }
    )
}
