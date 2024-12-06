//
//  PaywallSubscriptionsView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

struct PaywallSubscriptionsView: View {
    @Binding var isTrial: Bool
    @Binding var selectedPlan: ProductType
    
    @State private var currentPlanIndex = 1

    var availablePlans: [ProductType] {
        isTrial ? [
            .featureYearlyTrial,
            .featureMonthlyTrial,
            .featureWeeklyTrial
        ] : [
            .featureYearly,
            .featureMonthly,
            .featureWeekly
        ]
    }

    var body: some View {
        ZStack {
            Image(.background2)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Remove worries about hidden cameras")
                        .font(AppFont.text.font)
                    Text("Test your network connection")
                        .font(AppFont.text.font)
                    Text("Detect and evaluate nearby devices")
                        .font(AppFont.text.font)
                }
                .padding(.top, 16)
                Spacer()
                HStack(spacing: 8) {
                    ForEach(availablePlans, id: \.self) { plan in
                        PaywallSubscriptionCardView(plan: plan, isSelected: selectedPlan == plan)
                            .onTapGesture {
                                withAnimation {
                                    currentPlanIndex = availablePlans.firstIndex(of: plan) ?? 0
                                    selectedPlan = plan
                                }
                            }
                    }
                }
                Spacer()
                Toggle(isOn: $isTrial) {
                    Text("Free Trial \(isTrial ? "Enabled" : "Disabled")")
                        .font(AppFont.text.font)
                        .foregroundStyle(.gray80)
                }
                .toggleStyle(SwitchToggleStyle(tint: .primaryApp))
                .padding(.bottom, 32)
                .onChange(of: isTrial) { _ in
                    updateSelectedPlan()
                }
            }
        }
    }
    
    private func updateSelectedPlan() {
        if currentPlanIndex < availablePlans.count {
            selectedPlan = availablePlans[currentPlanIndex]
        } else {
            selectedPlan = availablePlans.first ?? .featureYearly
        }
    }
}

#Preview {
    PaywallSubscriptionsView(isTrial: .constant(true), selectedPlan: .constant(.featureWeeklyTrial))
        .environmentObject(IAPViewModel())
}
