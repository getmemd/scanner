//
//  RadarLoader.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct RadarLoader: View {
    @Binding var progress: Double
    
    private let circleSizes: [CGFloat] = [300, 200, 100]
    
    var body: some View {
        ZStack {
            ForEach(circleSizes, id: \.self) { size in
                ZStack {
                    Circle()
                        .stroke(.third, lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: calculateProgress(size: size))
                        .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .fill(.primaryApp)
                        .animation(.smooth(duration: 1), value: progress)
                }
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
            }
        }
    }
    
    private func calculateProgress(size: CGFloat) -> Double {
        return progress / size * 100 * 3
    }
}

#Preview {
    RadarLoader(progress: .constant(0.9))
}
