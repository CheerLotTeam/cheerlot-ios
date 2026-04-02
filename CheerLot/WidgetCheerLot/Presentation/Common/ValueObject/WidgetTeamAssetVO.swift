//
//  WidgetTeamAssetVO.swift
//  CheerLot
//
//  Created by 이승진 on 4/1/26.
//

import SwiftUI

final class WidgetTeamAssetVO {
  private let teamId: String
  private let assetPrefix: String

  init(_ teamId: String) {
    self.teamId = teamId.uppercased()
    self.assetPrefix = Self.getAssetPrefix(for: teamId)
  }

  lazy var shortName: String = {
    Self.getShortName(for: teamId)
  }()

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
  private static func getShortName(for teamId: String) -> String {
    switch teamId.uppercased() {
    case "HANWHA": return "한화"
    case "LG": return "LG"
    case "LOTTE": return "롯데"
    case "SAMSUNG": return "삼성"
    case "NC": return "NC"
    case "KT": return "KT"
    case "SSG": return "SSG"
    case "DOOSAN": return "두산"
    case "KIWOOM": return "키움"
    case "KIA": return "KIA"
    default: return teamId
    }
  }

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
