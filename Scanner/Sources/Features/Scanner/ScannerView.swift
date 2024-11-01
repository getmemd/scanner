//
//  ScannerView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import SwiftUI

struct ScannerView: View {
    enum ViewState {
        case wifi
        case bluetooth
        
        var title: String {
            switch self {
            case .wifi: "Wi-Fi Scanner"
            case .bluetooth: "Bluetooth Scanner"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .wifi: "SEARCH DEVICES ON SHARED WI-FI"
            case .bluetooth: "SEARCH FOR BLUETOOTH DEVICES"
            }
        }
    }
    
    @State private var viewState: ViewState = .wifi
    
    var body: some View {
        VStack {
            HStack {
                Text(viewState.title)
                    .font(AppFont.h4.font)
                    .foregroundStyle(.primaryApp)
                Spacer()
            }
            HStack(spacing: 4) {
                Button(action: {
                    viewState = .wifi
                }) {
                    HStack {
                        Image(.homeWifi)
                        Text("WI-FI")
                            .font(AppFont.button.font)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewState == .wifi ? .second : .third)
                    .foregroundStyle(viewState == .wifi ? .gray0 : .gray70)
                }
                Button(action: {
                    viewState = .bluetooth
                }) {
                    HStack {
                        Image(.bluetooth)
                        Text("BLUETOOTH")
                            .font(AppFont.button.font)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewState == .bluetooth ? .second : .third)
                    .foregroundStyle(viewState == .bluetooth ? .gray0 : .gray70)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.vertical, 40)
            Spacer()
            RadarLoader()
            Spacer()
            Button(action: {
                
            }) {
                Text(viewState.buttonTitle)
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 16)
        }
        .padding([.bottom, .horizontal], 32)
        .background(Color.forth.ignoresSafeArea())
    }
}

#Preview {
    ScannerView()
}
