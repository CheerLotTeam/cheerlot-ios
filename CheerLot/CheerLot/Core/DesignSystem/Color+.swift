//
//  Color+.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import SwiftUI

extension Color {
    
    struct TeamColorSet {
        let primary: Color
        let secondary: Color
    }
    
    static let appPrimary: Color = .sky600
    static let appSecondary: Color = .seam400
    
    static let hanwhaPrimary = Color.hhOrange400
    static let hanwhaSecondary = Color.hhOrange400
    
    static let lgPrimary = Color.lgRed400
    static let lgSecondary = Color.lgRed400
    
    static let lottePrimary = Color.ltNavy400
    static let lotteSecondary = Color.ltRed400
    
    static let samsungPrimary = Color.ssBlue400
    static let samsungSecondary = Color.ssBlue400
    
    static let ncPrimary = Color.ncDeepblue400
    static let ncSecondary = Color.ncGold400
    
    static let ktPrimary = Color.ktJetblack400
    static let ktSecondary = Color.ktRed400
    
    static let ssgPrimary = Color.ssgDeepred400
    static let ssgSecondary = Color.ssgDeepred400
    
    static let doosanPrimary = Color.dsMidnight400
    static let doosanSecondary = Color.dsRed400
    
    static let kiwoomPrimary = Color.kwBurgundy400
    static let kiwoomSecondary = Color.kwBurgundy400
    
    static let kiaPrimary = Color.kiaScarlet400
    static let kiaSecondary = Color.kiaScarlet400
    
    // Team Colors by prefixDesignCode
    static func teamColors(for assetPrefix: String) -> TeamColorSet {
        switch assetPrefix {
        case "hh":
            return TeamColorSet(primary: .hanwhaPrimary, secondary: .hanwhaSecondary)
        case "lg":
            return TeamColorSet(primary: .lgPrimary, secondary: .lgSecondary)
        case "lt":
            return TeamColorSet(primary: .lottePrimary, secondary: .lotteSecondary)
        case "ss":
            return TeamColorSet(primary: .samsungPrimary, secondary: .samsungSecondary)
        case "nc":
            return TeamColorSet(primary: .ncPrimary, secondary: .ncSecondary)
        case "kt":
            return TeamColorSet(primary: .ktPrimary, secondary: .ktSecondary)
        case "ssg":
            return TeamColorSet(primary: .ssgPrimary, secondary: .ssgSecondary)
        case "ds":
            return TeamColorSet(primary: .doosanPrimary, secondary: .doosanSecondary)
        case "kw":
            return TeamColorSet(primary: .kiwoomPrimary, secondary: .kiwoomSecondary)
        case "kia":
            return TeamColorSet(primary: .kiaPrimary, secondary: .kiaSecondary)
        default:
            return TeamColorSet(primary: .appPrimary, secondary: .appSecondary)
        }
    }
}
