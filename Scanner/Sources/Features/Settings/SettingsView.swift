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
    @State private var path: [OptionType] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
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
                                Spacer()
                                Image(.arrowRight)
                            }
                            .foregroundStyle(.gray80)
                        }
                        .listRowSeparatorTint(.third)
                    }
                }
                .scrollContentBackground(.hidden)
                .clipShape(.rect(cornerRadius: 16))
            }
            .background(Color.forth)
            .navigationDestination(for: OptionType.self) { option in
                switch option {
                case .review:
                    EmptyView()
                case .share:
                    EmptyView()
                case .restore:
                    EmptyView()
                case .terms:
                    InfoView(viewState: .terms)
                case .privacy:
                    InfoView(viewState: .privacy)
                case .contact:
                    EmptyView()
                }
            }
        }
    }
    
    private func handleAction(_ option: OptionType) {
        switch option {
        case .review:
            requestReview()
        case .share:
            shareApp()
        case .restore:
            Task {
                do {
                    try await restorePurchases()
                } catch {
                    print(error)
                }
            }
        case .terms, .privacy:
            path = [option]
        default:
            break
        }
    }
    
    private func shareApp() {
        let url = URL(string: "https://apple.com")
        let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
    
    private func restorePurchases() async throws {
        try await StoreKit.AppStore.sync()
    }
}

#Preview {
    SettingsView()
}
