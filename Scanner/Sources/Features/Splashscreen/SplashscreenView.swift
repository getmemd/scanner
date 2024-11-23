//
//  SplashscreenView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

struct SplashscreenView: View {
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    private let splashImages: [ImageResource] = [.splashscreen1, .splashscreen2, .splashscreen3]
    
    var body: some View {
        ZStack {
            Color.forth
            Image(splashImages[currentIndex])
                .resizable()
                .scaledToFit()
                .animation(.easeInOut(duration: 0.7), value: currentIndex)
                .onAppear(perform: startTimer)
                .onDisappear(perform: stopTimer)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % splashImages.count
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    SplashscreenView()
}
