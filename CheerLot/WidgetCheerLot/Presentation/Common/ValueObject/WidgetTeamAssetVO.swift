//
//  WidgetTeamAssetVO.swift
//  CheerLot
//
//  Created by 이승진 on 4/1/26.
//

import SwiftUI

final class WidgetTeamAssetVO {
  private let assetPrefix: String

  init(_ teamId: String) {
    self.assetPrefix = Self.getAssetPrefix(for: teamId)
  }

  lazy var colors: Color.TeamColorSet = {
    Color.teamColors(for: assetPrefix)
  }()

  var primaryColor: Color { colors.primary }
  var secondaryColor: Color { colors.secondary }

  // 위젯 전용 커버 이미지
  lazy var coverImageName: String = {
    "\(assetPrefix)_cover"
  }()

  lazy var coverImage: Image = {
    Image(coverImageName)
  }()
}

extension WidgetTeamAssetVO {
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
