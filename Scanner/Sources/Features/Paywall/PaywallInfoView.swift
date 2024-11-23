//
//  PaywallInfoView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

struct PaywallInfoView: View {
    @Binding var showPaywall: Bool
    @EnvironmentObject var iapViewModel: IAPViewModel
    
    var body: some View {
        ZStack {
            Image(.background1)
            VStack(spacing: 8) {
                Spacer()
                Image(.shield)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Unlock the full potential with our premium version!")
                        .font(AppFont.h4.font)
                    VStack {
                        Text("Unlock the full app experience with a risk-free 3-day free trial, followed by \(iapViewModel.localizedPrices[.featureWeeklyTrial] ?? "Error") per week, ") + Text(
                            "or continue using the limited version."
                        )
                        .underline()
                        .font(AppFont.text.font)
                    }
                    .onTapGesture {
                        showPaywall = false
                    }
                }
            }
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    PaywallInfoView(showPaywall: .constant(true))
        .environmentObject(IAPViewModel())
}
