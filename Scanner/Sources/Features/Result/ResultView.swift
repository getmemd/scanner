//
//  ResultView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct ResultView<T: Codable>: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var deviceManager: DeviceManager<T>
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Found devices: \(deviceManager.devices.count)")
                    .font(AppFont.h5.font)
                    .foregroundColor(.gray90)
                Spacer()
                Text("Dubious devices: \(deviceManager.devicesFiltered(by: false).count)")
                    .font(AppFont.h5.font)
                    .foregroundColor(.error)
            }
            DeviceListView<T>()
                .environmentObject(deviceManager)
            Spacer()
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.forth.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(.arrowLeft)
                            .foregroundColor(.gray90)
                        Text("Result")
                            .font(AppFont.h4.font)
                            .foregroundColor(.primaryApp)
                    }
                }
            }
        }
    }
}
