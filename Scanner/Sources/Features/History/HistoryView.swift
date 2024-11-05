//
//  HistoryView.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 04.11.2024.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        VStack {
            Text("History")
                .font(AppFont.h4.font)
                .foregroundStyle(.primaryApp)
                .padding(.bottom)
            HStack {
                Text("You have no search history yet")
                    .font(AppFont.h5.font)
                    .foregroundColor(.gray90)
                Spacer()
            }
            HStack {
                Text("Start using the app to have a check history. ")
                    .font(AppFont.text.font)
                    .foregroundColor(.gray80)
                Spacer()
            }
            Spacer()
            Button(action: {
                
            }) {
                Text("SEARCH DEVICES ON SHARED WI-FI")
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
            Button(action: {
               
            }) {
                Text("SEARCH FOR BLUETOOTH DEVICES")
                    .font(AppFont.button.font)
                    .foregroundColor(.gray10)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryApp)
                    .cornerRadius(12)
            }
        }
        .padding([.bottom, .horizontal], 32)
        .background(Color.forth.ignoresSafeArea())
    }
}

#Preview {
    HistoryView()
}
