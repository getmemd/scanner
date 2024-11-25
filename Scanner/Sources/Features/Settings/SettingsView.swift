//
//  SettingsView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    enum OptionType: CaseIterable, Hashable {
        case review
        case share
        case restore
        case terms
        case privacy
        case contact
        
        var text: String {
            switch self {
            case .review: "Leave a Review"
            case .share: "Share app"
            case .restore: "Restore purchases"
            case .terms: "Terms of Use"
            case .privacy: "Privacy Policy"
            case .contact: "Contact Us"
            }
        }
        
        var icon: ImageResource {
            switch self {
            case .review: .like
            case .share: .shareCircle
            case .restore: .delivery
            case .terms: .checklist
            case .privacy: .shieldCheck
            case .contact: .phoneCalling
            }
        }
    }
    
    @Environment(\.requestReview) var requestReview
    @Environment(\.openURL) var openURL
    @EnvironmentObject var iapViewModel: IAPViewModel
    @State private var showPaywall = false
    @State private var path: [OptionType] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                Text("Settings")
                    .font(AppFont.h4.font)
                    .foregroundStyle(.primaryApp)
                List {
                    ForEach(OptionType.allCases, id: \.self) { option in
                        Button(action: {
                            handleAction(option)
                        }) {
                            HStack {
                                Image(option.icon)
                                Text(option.text)
                                    .font(AppFont.text.font)
                                    .foregroundStyle(.gray80)
                                Spacer()
                                Image(.arrowRight)
                            }
                            .foregroundStyle(.gray80)
                            .padding(8)
                        }
                        .listRowSeparatorTint(.third)
                    }
                }
                .scrollContentBackground(.hidden)
                .clipShape(.rect(cornerRadius: 16))
                if !iapViewModel.isSubscribed {
                    VStack(spacing: 16) {
                        Button(action: {
                            showPaywall = true
                            generateHapticFeedback()
                        }) {
                            Text("GO PREMIUM NOW")
                                .font(AppFont.button.font)
                                .foregroundColor(.gray10)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.primaryApp)
                                .cornerRadius(12)
                        }
                        .padding()
                        HStack(alignment: .bottom) {
                            Text("Access all app features and enjoy comprehensive benefits, with additional options and enhanced functionality.")
                                .font(AppFont.text.font)
                                .foregroundStyle(.gray80)
                                .padding()
                            Image(.premium)
                                .foregroundStyle(.warning)
                                .padding()
                        }
                    }
                    .background(.gray0)
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.primaryApp, lineWidth: 1)
                    )
                    .padding()
                }
            }
            .background(Color.forth)
            .navigationDestination(for: OptionType.self) { option in
                switch option {
                case .terms:
                    InfoView(viewState: .terms)
                case .privacy:
                    InfoView(viewState: .privacy)
                default:
                    EmptyView()
                }
            }
            .onChange(of: iapViewModel.subscriptionEndDate) { newValue in
                if newValue > Date.now.timeIntervalSinceReferenceDate {
                    showPaywall = false
                }
            }
            .fullScreenCover(isPresented: $showPaywall, content: {
                PaywallView(viewState: .constant(.subscriptions), showPaywall: $showPaywall)
            })
        }
    }
    
    private func handleAction(_ option: OptionType) {
        switch option {
        case .review:
            requestReview()
        case .share:
            shareApp()
        case .restore:
            restorePurchases()
        case .terms, .privacy:
            path = [option]
        case .contact:
            mailTo()
        }
    }
    
    private func shareApp() {
        guard let url = URL(string: AppConstants.appLink) else { return }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
    
    private func mailTo() {
        let mailto = "mailto:\(AppConstants.email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(mailto ?? "")
        if let url = URL(string: mailto!) {
            openURL(url)
        }
    }
    
    private func restorePurchases() {
        Task {
            await iapViewModel.restore()
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    SettingsView()
        .environmentObject(IAPViewModel())
}
