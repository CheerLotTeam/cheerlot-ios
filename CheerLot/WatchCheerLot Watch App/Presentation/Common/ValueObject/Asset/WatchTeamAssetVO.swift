//
//  WatchTeamAssetVO.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import SwiftUI

/// Watch 전용 팀별 Asset 리소스를 관리하는 VO
final class WatchTeamAssetVO {
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
  var bgGradientColor: Color { colors.bgGradient }

  var bgGradient: LinearGradient {
    LinearGradient(
      gradient: Gradient(stops: [
        .init(color: bgGradientColor.opacity(0.0), location: 0.0),
        .init(color: bgGradientColor, location: 0.8),
      ]),
      startPoint: .top,
      endPoint: .bottom
    )
  }
}

extension WatchTeamAssetVO {
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
