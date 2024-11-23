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
    
    var title: String {
        switch self {
        case .featureWeekly, .featureWeeklyTrial:
            return "Week"
        case .featureMonthly, .featureMonthlyTrial:
            return "Month"
        case .featureYearly, .featureYearlyTrial:
            return "Year"
        }
    }
    
    var description: String {
        switch self {
        case .featureWeekly:
            return "Get weekly plan"
        case .featureMonthly:
            return "Get monthly plan"
        case .featureYearly:
            return "Get annual plan"
        case .featureWeeklyTrial, .featureMonthlyTrial, .featureYearlyTrial:
            return "Get 3 Days Free Trial"
        }
    }
}
