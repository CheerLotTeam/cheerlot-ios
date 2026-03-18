//
//  TeamAssetVO.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import SwiftUI

/// 팀별 Asset 리소스를 관리하는 VO
final class TeamAssetVO {
  private let assetPrefix: String
  
  init(_ teamId: TeamID) {
    self.assetPrefix = Self.getAssetPrefix(for: teamId.value)
  }
  
  // MARK: - Colors
  lazy var colors: Color.TeamColorSet = {
    Color.teamColors(for: assetPrefix)
  }()
  
  var primaryColor: Color { colors.primary }
  var secondaryColor: Color { colors.secondary }
  
  lazy var primaryPalette: Color.TeamPrimaryPalette = {
    Color.teamPrimaryPalette(for: assetPrefix)
  }()
  
  lazy var secondaryPalette: Color.TeamSecondaryPalette = {
    Color.teamSecondaryPalette(for: assetPrefix)
  }()
  
  lazy var coverImageName: String = {
    "\(assetPrefix)_cover"
  }()
  
  lazy var coverImage: Image = {
    Image(coverImageName)
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
