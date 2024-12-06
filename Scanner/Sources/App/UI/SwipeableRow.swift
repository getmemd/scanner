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
            .onChanged { gesture in
                if offset == 0 && gesture.translation.width > 0 {
                    return
                }
                if gesture.translation.width < -50 {
                    return
                }
                if offset == -50 && gesture.translation.width < 0 {
                    return
                }
                if offset >= -50 {
                    if gesture.translation.width > 50 {
                        self.offset = .zero
                        return
                    }
                    if offset != 0 && gesture.translation.width > 0 {
                        self.offset = -50 + gesture.translation.width
                        return
                    }
                }
                self.offset = gesture.translation.width
            }
            .onEnded { gesture in
                withAnimation {
                    if self.offset < -30 {
                        self.offset = -50
                        return
                    }
                    if self.offset < -50 {
                        self.offset = -50
                        return
                    }
                    if gesture.translation.width > 30 {
                        self.offset = .zero
                        return
                    }
                    if gesture.translation.width < 30 {
                        self.offset = -50
                        return
                    }
                    self.offset = .zero
                }
            }
    }
}
