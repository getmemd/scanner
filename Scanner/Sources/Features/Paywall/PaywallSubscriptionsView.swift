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
                    ForEach(
                        isOn ? [
                            ProductType.featureYearly,
                            .featureMonthly,
                            .featureWeekly
                        ] : [
                            .featureYearlyTrial,
                            .featureMonthlyTrial,
                            .featureWeeklyTrial
                        ],
                        id: \.self
                    ) { plan in
                        PaywallSubscriptionCardView(plan: plan, isSelected: selectedPlan == plan)
                            .onTapGesture {
                                withAnimation {
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
            }
        }
    }
}

#Preview {
    PaywallSubscriptionsView(isOn: .constant(true), selectedPlan: .constant(.featureWeeklyTrial))
        .environmentObject(IAPViewModel())
}
