//
//  InfoView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 02.11.2024.
//

import SwiftUI

struct InfoView: View {
    enum ViewState {
        case terms
        case privacy
        
        var title: String {
            switch self {
            case .terms:
                "Terms of Service"
            case .privacy:
                "Privacy Policy"
            }
        }
        
        var description: String {
            switch self {
            case .terms:
                """
                VPN Maker built the Fast VPN app as a Free app. This SERVICE is provided by VPN Maker at no cost and is intended for use as is.
                
                This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.
                
                If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.
                
                The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Fast VPN unless otherwise defined in this Privacy Policy.
                VPN Maker built the Fast VPN app as a Free app. This SERVICE is provided by VPN Maker at no cost and is intended for use as is.
                
                This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.
                
                If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.
                
                The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Fast VPN unless otherwise defined in this Privacy Policy.
                """
            case .privacy:
                """
                VPN Maker built the Fast VPN app as a Free app. This SERVICE is provided by VPN Maker at no cost and is intended for use as is.

                This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.

                If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.

                The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Fast VPN unless otherwise defined in this Privacy Policy.
                VPN Maker built the Fast VPN app as a Free app. This SERVICE is provided by VPN Maker at no cost and is intended for use as is.

                This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.

                If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.

                The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Fast VPN unless otherwise defined in this Privacy Policy.
                """
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    let viewState: ViewState
    
    var body: some View {
        ScrollView {
            VStack {
                Text(viewState.description)
                    .font(AppFont.smallText.font)
                    .foregroundStyle(.gray90)
                    .padding(24)
            }
            .background(.gray0)
            .clipShape(.rect(cornerRadius: 16))
            .padding(32)
        }
        .background(.third)
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(.arrowLeft)
                        .foregroundStyle(.gray80)
                }
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .principal) {
                Text(viewState.title)
                    .font(AppFont.h4.font)
                    .foregroundStyle(.primaryApp)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InfoView(viewState: .terms)
}
