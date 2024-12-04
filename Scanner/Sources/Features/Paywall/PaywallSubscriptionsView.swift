//
//  PaywallSubscriptionsView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import SwiftUI

struct PaywallSubscriptionsView: View {
    @Binding var isOn: Bool
    @Binding var selectedPlan: ProductType
    
    @State private var currentPlanIndex = 1

    var availablePlans: [ProductType] {
        isOn ? [
            .featureYearly,
            .featureMonthly,
            .featureWeekly
        ] : [
            .featureYearlyTrial,
            .featureMonthlyTrial,
            .featureWeeklyTrial
        ]
    }

    var body: some View {
        ZStack {
            Image(.background2)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
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
                Toggle(isOn: $isOn) {
                    Text("Free Trial \(isOn ? "Enabled" : "Disabled")")
                        .font(AppFont.text.font)
                        .foregroundStyle(.gray80)
                }
                .toggleStyle(SwitchToggleStyle(tint: .primaryApp))
                .padding(.bottom, 32)
                .onChange(of: isOn) { _ in
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
    PaywallSubscriptionsView(isOn: .constant(true), selectedPlan: .constant(.featureWeeklyTrial))
        .environmentObject(IAPViewModel())
}
