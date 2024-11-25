//
//  TabManager.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 26.11.2024.
//

import Foundation

final class TabManager: ObservableObject {
    @Published var selectedTab: Int = 2
    @Published var scannerViewState: ScannerView.ViewState = .bluetooth
}
