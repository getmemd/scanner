//
//  OnboardingPageViewModel.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 15.11.2024.
//

import Foundation

struct OnboardingPageViewModel: Identifiable {
    var id = UUID()
    let title: String
    let description: String
    let image: ImageResource
}
