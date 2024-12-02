//
//  PaywallSubscriptionCardView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

struct PaywallSubscriptionCardView: View {
    let plan: ProductType
    let isSelected: Bool
    
    @EnvironmentObject var iapViewModel: IAPViewModel
    
    var body: some View {
        VStack {
            Text(plan.title)
                .font(AppFont.h4.font)
                .foregroundStyle(isSelected ? .gray0 : .gray80)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Spacer()
            Text(iapViewModel.localizedPrices[plan] ?? "Error")
                .font(AppFont.h5.font)
                .foregroundStyle(isSelected ? .gray0 : .gray80)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            Text(plan.description)
                .font(AppFont.smallText.font)
                .foregroundStyle(isSelected ? .gray40 : .gray70)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: isSelected ? 190 : 180)
        .background(isSelected ? .primaryApp : .gray0)
        .cornerRadius(12)
    }
}

#Preview {
    PaywallSubscriptionCardView(plan: .featureWeeklyTrial, isSelected: true)
        .environmentObject(IAPViewModel())
}
