//
//  ProductType.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 17.11.2024.
//

import Foundation

enum ProductType: String, Codable, CaseIterable {
    case featureWeekly
    case featureMonthly
    case featureYearly
    case featureWeeklyTrial
    case featureMonthlyTrial
    case featureYearlyTrial
    
    var packageID: String {
        switch self {
        case .featureWeekly:
            return AppConstants.featureWeeklyPackageID
        case .featureMonthly:
            return AppConstants.featureMonthlyPackageID
        case .featureYearly:
            return AppConstants.featureYearlyPackageID
        case .featureWeeklyTrial:
            return AppConstants.featureWeeklyTrialPackageID
        case .featureMonthlyTrial:
            return AppConstants.featureMonthlyTrialPackageID
        case .featureYearlyTrial:
            return AppConstants.featureYearlyTrialPackageID
        }
    }
}
