//
//  RadarLoader.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct RadarLoader: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            ForEach([300, 200, 100], id: \.self) { size in
                Circle()
                    .stroke(Color.third, lineWidth: 6)
                    .frame(width: CGFloat(size), height: CGFloat(size))
            }
            ForEach([(300, 0.25, 0.5), (200, 0.0, 0.5), (100, 0.0, 0.5)], id: \.0) { size, start, end in
                Circle()
                    .trim(from: start, to: end)
                    .stroke(Color.primaryApp, lineWidth: 6)
                    .frame(width: CGFloat(size), height: CGFloat(size))
            }
            .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 2)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}

#Preview {
    RadarLoader()
}
