//
//  ResultView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI

struct ResultView<T: Codable>: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var devices: [Device<T>] = []
    
    private var secureDevices: [Device<T>] {
        devices.filter { $0.isSecure }
    }
    
    private var dubiousDevices: [Device<T>] {
        devices.filter { !$0.isSecure }
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Found devices: \(devices.count)")
                    .font(AppFont.h5.font)
                    .foregroundColor(.gray90)
                Spacer()
                Text("Dubious devices: \(dubiousDevices.count)")
                    .font(AppFont.h5.font)
                    .foregroundColor(.error)
            }
            DeviceListView(devices: secureDevices, isSecure: true)
            DeviceListView(devices: dubiousDevices, isSecure: false)
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
