//
//  TeamMembersAssetVO.swift
//  CheerLot
//
//  Created by 이승진 on 2/3/26.
//

import SwiftUI

/// 전체 선수 화면 전용 Asset VO입니다.
struct TeamMembersAssetVO {
  
  // MARK: - Properties
  let base: TeamAssetVO
  
  // MARK: - Init
  init(team: TeamInfo) {
    self.base = TeamAssetVO(team: team)
  }
  
  init(base: TeamAssetVO) {
    self.base = base
  }
  
  // MARK: - Base Colors
  
  /// 팀 Primary 컬러
  var primaryColor: Color {
    base.primary
  }
  
  /// 팀 Secondary 컬러
  var secondaryColor: Color {
    base.secondary
  }
  
  // MARK: - Team Card
  
  /// 카드 배경 그라데이션 시작
  var cardGradientStart: Color {
    switch base.team.id {
    case "SAMSUNG": return .ssBlue200
    case "HANWHA": return .hhOrange100
    case "LG": return .lgRed100
    case "LOTTE": return .ltNavy200
    case "NC": return .ncDeepblue100
    case "SSG": return .ssgDeepred100
    case "DOOSAN": return .dsMidnight200
    case "KT": return .ktJetblack100
    case "KIWOOM": return .kwBurgundy100
    case "KIA": return .kiaScarlet100
    default:
      return primaryColor.opacity(0.2)
    }
  }
  
  /// 카드 배경 그라데이션 끝
  var cardGradientEnd: Color {
    switch base.team.id {
    case "SAMSUNG": return .ssBlue600
    case "HANWHA": return .hhOrange600
    case "LG": return .lgRed600
    case "LOTTE": return .ltNavy600
    case "NC": return .ncDeepblue600
    case "SSG": return .ssgDeepred600
    case "DOOSAN": return .dsMidnight600
    case "KT": return .ktJetblack600
    case "KIWOOM": return .kwBurgundy600
    case "KIA": return .kiaScarlet600
    default:
      return primaryColor
    }
  }
  
  /// 카드 배경 그라데이션
  var cardBackgroundGradient: LinearGradient {
    LinearGradient(
      colors: [
        cardGradientStart,
        cardGradientEnd
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }
  
  /// 카드 서브 텍스트 컬러 (200)
  var cardSubtitleColor: Color {
    switch base.team.id {
    case "SAMSUNG": return .ssBlue200
    case "HANWHA": return .hhOrange200
    case "LG": return .lgRed200
    case "LOTTE": return .ltNavy200
    case "NC": return .ncDeepblue200
    case "SSG": return .ssgDeepred200
    case "DOOSAN": return .dsMidnight200
    case "KT": return .ktJetblack200
    case "KIWOOM": return .kwBurgundy200
    case "KIA": return .kiaScarlet200
    default:
      return secondaryColor
    }
  }
  
  /// 카드 텍스트 그림자 컬러 (600)
  var cardTextShadowColor: Color {
    switch base.team.id {
    case "SAMSUNG": return .ssBlue600
    case "HANWHA": return .hhOrange600
    case "LG": return .lgRed600
    case "LOTTE": return .ltNavy600
    case "NC": return .ncDeepblue600
    case "SSG": return .ssgDeepred600
    case "DOOSAN": return .dsMidnight600
    case "KT": return .ktJetblack600
    case "KIWOOM": return .kwBurgundy600
    case "KIA": return .kiaScarlet600
    default:
      return primaryColor
    }
  }
}
