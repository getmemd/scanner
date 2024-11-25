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
        NavigationStack {
            VStack {
                if viewModel.devices.isEmpty {
                    HistoryEmptyView()
                } else {
                    HistoryListView()
                        .environmentObject(viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text("History")
                        .font(AppFont.h4.font)
                        .foregroundStyle(.primaryApp)
                        .padding(.bottom)
                }
            }
        }
        .background(Color.forth.ignoresSafeArea())
        .onAppear {
            viewModel.loadHistory()
        }
    }
}

#Preview {
    HistoryView()
}
