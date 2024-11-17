//
//  PaywallSubscriptionCardView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

enum SubscriptionType: CaseIterable {
    case yearly, monthly, weekly
    
    var title: String {
        switch self {
        case .yearly: return "Year"
        case .monthly: return "Month"
        case .weekly: return "Week"
        }
    }
    
    var price: String {
        switch self {
        case .yearly: return "$ 83.99"
        case .monthly: return "$ 14.99"
        case .weekly: return "$ 6.99"
        }
    }
    
    var description: String {
        switch self {
        case .yearly: return "Get annual plan"
        case .monthly: return "Get monthly plan"
        case .weekly: return "Get weekly plan"
        }
    }
}

struct PaywallSubscriptionCardView: View {
    let plan: SubscriptionType
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text(plan.title)
                .font(AppFont.h4.font)
                .foregroundStyle(isSelected ? .gray0 : .gray80)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Spacer()
            Text(plan.price)
                .font(AppFont.h5.font)
                .foregroundStyle(isSelected ? .gray0 : .gray80)
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
    PaywallSubscriptionCardView(plan: .weekly, isSelected: true)
}
