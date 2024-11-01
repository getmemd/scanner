//
//  AppFont.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import Foundation

import SwiftUI

enum AppFont {
    static let regularFont = "BricolageGrotesque-Regular"
    static let regularSemiBold = "BricolageGrotesque-SemiBold"
    static let regularExtraBold = "BricolageGrotesque-ExtraBold"

    case h5
    case h4
    case button
    case text
    case smallText
    case custom(size: CGFloat, weight: Font.Weight = .regular)
    
    var font: Font {
        switch self {
        case .h5:
            return .custom(AppFont.regularFont, size: 18)
        case .h4:
            return .custom(AppFont.regularSemiBold, size: 24)
        case .button:
            return .custom(AppFont.regularExtraBold, size: 16)
        case .text:
            return .custom(AppFont.regularFont, size: 16)
        case .smallText:
            return .custom(AppFont.regularFont, size: 12)
        case .custom(let size, let weight):
            return .custom(AppFont.regularFont, size: size).weight(weight)
        }
    }
}
