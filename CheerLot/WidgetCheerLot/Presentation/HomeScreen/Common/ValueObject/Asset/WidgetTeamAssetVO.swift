//
//  WidgetTeamAssetVO.swift
//  CheerLot
//
//  Created by 이승진 on 4/1/26.
//

import SwiftUI

final class WidgetTeamAssetVO {
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

  var widgetBackgroundGradient: LinearGradient {
    LinearGradient(
      colors: [
        primaryPalette.color600,
        primaryPalette.color200,
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }

  // MARK: - Images

  var coverImageName: String { "\(assetPrefix)_cover" }
  var coverImage: Image { Image(coverImageName) }

  var noCoverImageName: String { "\(assetPrefix)_noCover" }
  var noCoverImage: Image { Image(noCoverImageName) }
}

extension WidgetTeamAssetVO {
  private static func getAssetPrefix(for teamId: String) -> String {
    switch teamId.uppercased() {
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
    default: return teamId.lowercased()
    }
  }
}
