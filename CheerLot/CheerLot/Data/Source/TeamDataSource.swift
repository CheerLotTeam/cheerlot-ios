//
//  TeamDataSource.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import Foundation

struct TeamDataSource {
  /// 실제 팀 목록 데이터
  enum TeamCode: String, CaseIterable {
    case doosan = "DOOSAN"
    case hanwha = "HANWHA"
    case kia = "KIA"
    case kiwoom = "KIWOOM"
    case kt = "KT"
    case lg = "LG"
    case lotte = "LOTTE"
    case nc = "NC"
    case samsung = "SAMSUNG"
    case ssg = "SSG"
  }

  /// APICode (서버 전용, TeamDataSource 내부에서만 사용)
  private enum APICode: String {
    case doosan = "ob"
    case hanwha = "hh"
    case kia = "ht"
    case kiwoom = "wo"
    case kt = "kt"
    case lg = "lg"
    case lotte = "lt"
    case nc = "nc"
    case samsung = "ss"
    case ssg = "sk"
  }

  /// TeamCode → TeamEntity 변환
  static func toEntity(_ code: TeamCode) -> TeamInfo {
    switch code {
    case .samsung:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "삼성",
        longName: "삼성 라이온즈",
        englishFullName: "SAMSUNG LIONS",
        slogan: "WIN or WOW!"
      )

    case .hanwha:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "한화",
        longName: "한화 이글스",
        englishFullName: "HANWHA EAGLES",
        slogan: "IT IS OUR TURN"
      )

    case .lg:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "LG",
        longName: "LG 트윈스",
        englishFullName: "LG TWINS",
        slogan: "무적 LG! 끝까지 TWINS!"
      )

    case .lotte:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "롯데",
        longName: "롯데 자이언츠",
        englishFullName: "LOTTE GIANTS",
        slogan: "투혼투지, GO HIGH"
      )

    case .nc:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "NC",
        longName: "NC 다이노스",
        englishFullName: "NC DINOS",
        slogan: "거침없이 가자! 위풍당당"
      )

    case .ssg:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "SSG",
        longName: "SSG 랜더스",
        englishFullName: "SSG LANDERS",
        slogan: "NO LIMITS, AMAZING LANDERS"
      )

    case .doosan:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "두산",
        longName: "두산 베어스",
        englishFullName: "DOOSAN BEARS",
        slogan: "TIME TO MOVE ON"
      )

    case .kt:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "KT",
        longName: "KT 위즈",
        englishFullName: "KT WIZ",
        slogan: "마법의 시작, 위대한 도약! GREAT KT"
      )

    case .kiwoom:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "키움",
        longName: "키움 히어로즈",
        englishFullName: "KIWOOM HEROES",
        slogan: "영웅, 도전, 승리"
      )

    case .kia:
      return TeamInfo(
        id: TeamID(code.rawValue),
        shortName: "KIA",
        longName: "기아 타이거즈",
        englishFullName: "KIA TIGERS",
        slogan: "다시, 뜨겁게 ALWAYS KIA TIGERS"
      )
    }
  }

  /// teamId → 서버 api code (서버 호출용)
  static func toAPICode(_ code: TeamCode) -> String {
    switch code {
    case .doosan: return APICode.doosan.rawValue
    case .hanwha: return APICode.hanwha.rawValue
    case .kia: return APICode.kia.rawValue
    case .kiwoom: return APICode.kiwoom.rawValue
    case .kt: return APICode.kt.rawValue
    case .lg: return APICode.lg.rawValue
    case .lotte: return APICode.lotte.rawValue
    case .nc: return APICode.nc.rawValue
    case .samsung: return APICode.samsung.rawValue
    case .ssg: return APICode.ssg.rawValue
    }
  }

  static func fromAPICode(_ apiCode: String) -> TeamCode? {
    let normalized =
      apiCode
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .lowercased()

    switch normalized {
    case APICode.doosan.rawValue: return .doosan
    case APICode.hanwha.rawValue: return .hanwha
    case APICode.kia.rawValue: return .kia
    case APICode.kiwoom.rawValue: return .kiwoom
    case APICode.kt.rawValue: return .kt
    case APICode.lg.rawValue: return .lg
    case APICode.lotte.rawValue: return .lotte
    case APICode.nc.rawValue: return .nc
    case APICode.samsung.rawValue: return .samsung
    case APICode.ssg.rawValue: return .ssg
    default: return nil
    }
  }

  /// TeamID → 서버 api code
  static func toAPICode(_ teamID: TeamID) -> String {
    guard let teamCode = TeamCode(rawValue: teamID.value) else {
      assertionFailure("Unknown TeamID: \(teamID.value)")
      return APICode.samsung.rawValue
    }
    return toAPICode(teamCode)
  }
}
