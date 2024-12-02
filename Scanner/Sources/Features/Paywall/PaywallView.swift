//
//  PaywallView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 15.11.2024.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    enum ViewState {
        case info
        case subscriptions
    }
    
    @State private var isTrialDisabled: Bool = false
    @State private var selectedPlan: ProductType = .featureMonthlyTrial
    @State private var isBouncing: Bool = false
    @Binding var viewState: ViewState
    @Binding var showPaywall: Bool
    @EnvironmentObject var viewModel: IAPViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Get full access")
                            .font(AppFont.h4.font)
                            .foregroundStyle(.primaryApp)
                        Spacer()
                        if viewState == .subscriptions {
                            Button {
                                showPaywall = false
                            } label: {
                                Image(.closeSquare)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.gray80)
                            }
                        }
                    }
                    if viewState == .info {
                        PaywallInfoView(showPaywall: $showPaywall)
                    } else if viewState == .subscriptions {
                        PaywallSubscriptionsView(isOn: $isTrialDisabled, selectedPlan: $selectedPlan)
                    }
                    Button {
                        generateHapticFeedback()
                        if viewState == .info {
                            withAnimation {
                                viewState = .subscriptions
                            }
                        } else {
                            viewModel.purchaseProduct(productType: selectedPlan)
                        }
                    } label: {
                        Text(viewState == .info ? "START TO CONTINUE" : "SUBSCRIBE")
                            .font(AppFont.button.font)
                            .foregroundColor(.gray10)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.primaryApp)
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.isPurchasing || viewModel.isLoadingSubs)
                    HStack {
                        Button {
                            Task {
                                await viewModel.restore()
                            }
                        } label: {
                            Text("Restore")
                                .font(AppFont.smallText.font)
                                .foregroundStyle(.gray70)
                        }
                        Spacer()
                        NavigationLink(destination: InfoView(viewState: .terms)) {
                            Text("Terms and conditions")
                                .font(AppFont.smallText.font)
                                .foregroundStyle(.gray70)
                        }
                        Spacer()
                        NavigationLink(destination: InfoView(viewState: .privacy)) {
                            Text("Privacy policy")
                                .font(AppFont.smallText.font)
                                .foregroundStyle(.gray70)
                        }
                    }
                    .padding(10)
                }
                .padding(.horizontal, 32)
                .background(.forth)
                if viewModel.isLoadingSubs || viewModel.isPurchasing {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.forth)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 10)
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.primaryApp)
                }
            }
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    PaywallView(viewState: .constant(.info), showPaywall: .constant(true))
        .environmentObject(IAPViewModel())
}
