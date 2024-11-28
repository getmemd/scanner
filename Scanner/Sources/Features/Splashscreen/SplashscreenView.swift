//
//  SplashscreenView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

struct SplashscreenView: View {
    @State private var rotationAngle: Double = 0
    @State private var imageScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.primaryApp, lineWidth: 2)
                .frame(width: 280, height: 280)
            Circle()
                .stroke(.second, lineWidth: 2)
                .frame(width: 220, height: 220)
            Circle()
                .fill(Color(hex: "#042225"))
                .frame(width: 180, height: 180)
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#F2FAFA"),
                            Color(hex: "#1C97A5"),
                            Color(hex: "#00606B")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 150, height: 150)
            Image(.lens)
                .resizable()
                .frame(width: 60, height: 60)
                .scaleEffect(imageScale)
                .animation(Animation.easeInOut(duration: 1.3).repeatForever(autoreverses: true), value: imageScale)
            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 25, height: 25)
                .offset(x: -30, y: -40)
                .rotationEffect(.degrees(-rotationAngle))
                .animation(Animation.linear(duration: 15).repeatForever(autoreverses: false), value: rotationAngle)
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 10, height: 10)
                .offset(x: 25, y: 30)
                .rotationEffect(.degrees(-rotationAngle))
                .animation(Animation.linear(duration: 15).repeatForever(autoreverses: false), value: rotationAngle)
            Circle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 15, height: 55)
                .offset(x: 40, y: 50)
                .rotationEffect(.degrees(-rotationAngle))
                .animation(Animation.linear(duration: 15).repeatForever(autoreverses: false), value: rotationAngle)
            
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        rotationAngle = 360
        imageScale = 1.5
    }
}

#Preview {
    SplashscreenView()
}
