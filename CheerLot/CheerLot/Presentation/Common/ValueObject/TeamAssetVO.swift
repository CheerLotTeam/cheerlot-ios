//
//  TeamAssetVO.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import SwiftUI

/// 팀별 Asset 리소스를 관리하는 VO
final class TeamAssetVO {
    let team: TeamInfo

    private let assetPrefix: String
    
    init(team: TeamInfo) {
        self.team = team
        self.assetPrefix = Self.getAssetPrefix(for: team.id)
    }
    
    // MARK: - Colors
    lazy var colors: Color.TeamColorSet = {
        Color.teamColors(for: assetPrefix)
    }()
    
    var primary: Color { colors.primary }
    var secondary: Color { colors.secondary }
    
    // MARK: - Background Images (후에 교체 요망)
    lazy var mainTopBackground: Image = {
        Image("\(assetPrefix)_mainTopBG")
    }()
    
    lazy var changeTopBackground: Image = {
        Image("\(assetPrefix)_changeTopBG")
    }()
    
    // MARK: - Cheer Song Images (후에 교체 요망)
    lazy var cheerSongHatImage: Image = {
        Image("\(assetPrefix)_hat")
    }()
    
    lazy var cheerSongBackground: Image = {
        Image("\(assetPrefix)_cheerSongBG")
    }()
    
    lazy var watchListBackground: Image = {
        Image("\(assetPrefix)_listBG")
    }()
}

extension TeamAssetVO {
    private static func getAssetPrefix(for teamId: String) -> String {
        let normalizedId = teamId.uppercased()
        
        switch normalizedId {
        case "HANWHA": return "hh"
        case "LG": return "lg"
        case "LOTTE": return "lt"
        case "SAMSUNG": return "ss"
        case "NC": return "nc"
        case "KT": return "kt"
        case "SSG": return "ssg"
        case "DOOSAN": return "ds"
        case "KIWOOM": return "kw"
        case "KIA": return "kia"
        default: return normalizedId.lowercased()
        }
    }
}
