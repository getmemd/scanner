//
//  PaywallInfoView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

struct PaywallInfoView: View {
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
                    Text("Unlock the full app experience with a risk-free 3-day free trial, followed by \(SubscriptionType.weekly.price) per week, ") + Text(
                        "or continue using the limited version."
                    )
                    .underline()
                        .font(AppFont.text.font)
                }
            }
        }
        .padding(.bottom, 32)
    }
}

#Preview {
    PaywallInfoView()
}
