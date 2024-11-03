//
//  CustomProgressView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 03.11.2024.
//

import SwiftUI

struct CustomProgressView<Shape: SwiftUI.Shape>: View {
    var value: Double
    var shape: Shape

    var body: some View {
        shape.fill(.third)
             .overlay(alignment: .leading) {
                 GeometryReader { proxy in
                     shape.fill(.tint)
                          .frame(width: proxy.size.width * value)
                 }
             }
             .tint(LinearGradient(colors: [.primaryApp, .second], startPoint: .leading, endPoint: .trailing))
    }
}

#Preview {
    VStack {
        CustomProgressView(value: 0.6, shape: Capsule())
    }
    .frame(height: 33)
    .padding()
}
