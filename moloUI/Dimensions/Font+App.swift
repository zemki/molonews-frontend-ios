//
//  Font+App.swift
//  Dimensions
//

import Foundation
import SwiftUI

public extension Font {
    /// 32.0 / semi
    static let moloTitleXLarge = Font.system(size: 32.0, weight: .semibold)
    /// 24.0 / black
    static let moloTitleLarge = Font.system(size: 24.0, weight: .black)
    /// 20.0 / bold
    static let moloTitleDefault = Font.system(size: 20.0, weight: .bold)
    /// 18.0 / bold
    static let moloTitleSmall = Font.system(size: 18.0, weight: .bold)

    /// 20.0 / semibold
    static let moloSubheading = Font.system(size: 20.0, weight: .semibold)

    /// 13.0 / bold
    static let moloSubtitleBold = Font.system(size: 13.0, weight: .bold)
    /// 13.0 / regular
    static let moloSubtitleRegular = Font.system(size: 13.0, weight: .regular)
    
    /// 14.0 / regular
    static let moloContentDefault = Font.system(size: 14.0, weight: .regular)
    
    /// 10.0 / light
    static let moloFooterLight = Font.system(size: 10.0, weight: .light)
    /// 12.0 / medium
    static let moloFooterMedium = Font.system(size: 12.0, weight: .medium)
    
    /// 18.0 / regular
    static let moloMenuItemDefault = Font.system(size: 18.0, weight: .regular)
    
    /// 16.0 / regular
    static let moloSourceSelectionTitle = Font.system(size: 16.0, weight: .regular)
    /// 20.0 / regular
    static let moloSourceSelection = Font.system(size: 20.0, weight: .regular)
}
