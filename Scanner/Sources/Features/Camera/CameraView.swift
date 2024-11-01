//
//  CameraView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var model = CameraDataModel()
    @State private var selectedFilter = FilterType.red
    
    var body: some View {
        VStack {
            HStack {
                Text("Camera Detector")
                    .font(AppFont.h4.font)
                    .foregroundStyle(Color.primaryApp)
                Spacer()
//                NavigationLink(destination: SettingsView()) {
//                    Image(.settings)
//                }
            }
            .padding()
            Spacer()
            GeometryReader { geometry in
                if let image = model.viewfinderImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .border(Color.black, width: 1)
                        .cornerRadius(16)
                } else {
                    RadarLoader()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .padding()
            Spacer()
            if model.viewfinderImage == nil {
                Button(action: {
                    Task {
                        await model.camera.start()
                    }
                }) {
                    Text("SEARCH VIA CAMERA DETECTOR")
                        .font(AppFont.button.font)
                        .foregroundColor(.gray10)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.primaryApp)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 16)
            }
            HStack(spacing: 32) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Button(action: {
                        model.camera.setFilter(filter)
                        selectedFilter = filter
                    }) {
                        switch filter {
                        case .red:
                            Image(selectedFilter == filter ? .redSelected : .red)
                        case .green:
                            Image(selectedFilter == filter ? .greenSelected : .green)
                        case .blue:
                            Image(selectedFilter == filter ? .blueSelected : .blue)
                        case .blackWhite:
                            Image(selectedFilter == filter ? .bwSelected : .bw)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(Color.forth.ignoresSafeArea())
//        .task {
//            await model.camera.start()
//        }
        .onDisappear {
            model.camera.stop()
            model.viewfinderImage = nil
        }
    }
}

#Preview {
    CameraView()
}
