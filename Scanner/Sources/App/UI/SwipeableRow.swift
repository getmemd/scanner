//
//  SwipeableRow.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.12.2024.
//

import SwiftUI

struct SwipeableRow<Content: View>: View {
    let content: () -> Content
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    onDelete()
                }) {
                    Image(.trashBinSquare)
                        .foregroundStyle(.error)
                        .padding(.horizontal)
                }
                .overlay(
                    Rectangle()
                        .frame(width: 1)
                        .foregroundStyle(.third),
                    alignment: .leading
                )
            }
            content()
                .background(Color.white)
                .offset(x: offset + translation)
                .gesture(dragGesture)
                .animation(.easeInOut(duration: 0.5), value: offset)
        }
        .clipped()
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($translation) { value, state, _ in
                if value.translation.width < 0 {
                    state = value.translation.width
                }
            }
            .onEnded { value in
                withAnimation {
                    if value.translation.width < -100 {
                        offset = -100
                    } else {
                        offset = 0
                    }
                }
            }
    }
}
