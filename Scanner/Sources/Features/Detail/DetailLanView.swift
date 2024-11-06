//
//  DetailLanView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 06.11.2024.
//

import SwiftUI
import LanScanner

struct DetailLanView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let lanDevice: LanDeviceModel?
    let isSecure: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(isSecure ? .checkSquare : .dangerSquare)
                        .foregroundColor(isSecure ? .success : .error)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(lanDevice?.name ?? "Unknown")
                            .font(AppFont.text.font)
                            .foregroundColor(.gray80)
                        Text(lanDevice?.ipAddress ?? "Unknown")
                            .font(AppFont.smallText.font)
                            .foregroundColor(.gray60)
                    }
                    Spacer()
                }
                .padding(.bottom, 8)
                Divider()
                HStack {
                    Text("IP Address")
                        .font(AppFont.text.font)
                        .foregroundColor(.gray80)
                    Spacer()
                    Text(lanDevice?.ipAddress ?? "Unknown")
                        .font(AppFont.smallText.font)
                        .foregroundColor(.gray60)
                }
                Divider()
                HStack {
                    Text("Mac Address")
                        .font(AppFont.text.font)
                        .foregroundColor(.gray80)
                    Spacer()
                    Text(lanDevice?.mac ?? "Unknown")
                        .font(AppFont.smallText.font)
                        .foregroundColor(.gray60)
                }
                Divider()
                HStack {
                    Text("Hostname")
                        .font(AppFont.text.font)
                        .foregroundColor(.gray80)
                    Spacer()
                    Text(lanDevice?.brand ?? "Unknown")
                        .font(AppFont.smallText.font)
                        .foregroundColor(.gray60)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSecure ? .success : .error, lineWidth: 1)
            )
            Spacer()
            Button(action: {
            }) {
                Text("SEARCH")
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
            Button(action: {
            }) {
                Text("LABEL THE DEVICE AS SAFE")
                    .font(AppFont.button.font)
                    .foregroundColor(isSecure ? .error : .success)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSecure ? .error : .success, lineWidth: 2)
                    )
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 8) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(.arrowLeft)
                            .foregroundColor(.gray90)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Device details")
                            .font(AppFont.h4.font)
                            .foregroundColor(.primaryApp)
                        HStack(spacing: 4) {
                            Image(.homeWifi)
                                .resizable()
                                .foregroundColor(.gray70)
                                .frame(width: 16, height: 16)
                            Text("Wi-Fi scanner")
                                .font(AppFont.smallText.font)
                                .foregroundColor(.gray70)
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.forth.ignoresSafeArea())
    }
}
