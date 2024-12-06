//
//  RadarLoader.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct RadarLoader: View {
    @Binding var progress: Double
    @State private var rotation = 0.0
    @State private var isAnimating: Bool = true
    @State private var throttledProgress: Double = 0.0
    
    private let circleSizes: [CGFloat] = [300, 200, 100]
    
    var body: some View {
        ZStack {
            ForEach(circleSizes, id: \.self) { size in
                ZStack {
                    Circle()
                        .stroke(.third, lineWidth: 6)
                    Circle()
                        .trim(from: calculateTrimStart(size: size), to: calculateProgress(size: size))
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .fill(.primaryApp)
                        .animation(.easeInOut(duration: 0.5), value: throttledProgress)
                }
                .rotationEffect(.degrees(rotation))
                .frame(width: size, height: size)
            }
            .rotationEffect(.degrees(-90))
        }
        .onAppear {
            updateRotationAnimation()
        }
        .onChange(of: progress) { newValue in
            throttledProgress = newValue
            isAnimating = newValue <= 0
        }
        .onChange(of: isAnimating) { _ in
            updateRotationAnimation()
        }
    }
    
    private func updateRotationAnimation() {
        if isAnimating {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        } else {
            withAnimation(.spring(duration: 1)) {
                rotation = 0
            }
        }
    }
    
    private func calculateTrimStart(size: CGFloat) -> Double {
        size == 300 && isAnimating ? 0.25 : 0
    }
    
    private func calculateProgress(size: CGFloat) -> Double {
        isAnimating ? 0.5 : throttledProgress / size * 100 * 3
    }
}

#Preview {
    RadarLoader(progress: .constant(0.0))
}
