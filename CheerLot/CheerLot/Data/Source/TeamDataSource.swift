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
    
    /// TeamCode → TeamEntity 변환
    static func toEntity(_ code: TeamCode) -> TeamInfo {
        switch code {
        case .samsung:
            return TeamInfo(
                id: "SAMSUNG",
                shortName: "삼성",
                longName: "삼성 라이온즈",
                englishFullName: "SAMSUNG LIONS",
                slogan: "WIN or WOW!"
            )
            
        case .hanwha:
            return TeamInfo(
                id: "HANWHA",
                shortName: "한화",
                longName: "한화 이글스",
                englishFullName: "HANHWA EAGLES",
                slogan: "RIDE THE STORM"
            )
            
        case .lg:
            return TeamInfo(
                id: "LG",
                shortName: "LG",
                longName: "LG 트윈스",
                englishFullName: "LG TWINS",
                slogan: "무적 LG! 끝까지 TWINS!"
            )
            
        case .lotte:
            return TeamInfo(
                id: "LOTTE",
                shortName: "롯데",
                longName: "롯데 자이언츠",
                englishFullName: "LOTTE GIANTS",
                slogan: "투혼투지! 승리를 위한 전진"
            )
            
        case .nc:
            return TeamInfo(
                id: "NC",
                shortName: "NC",
                longName: "NC 다이노스",
                englishFullName: "NC DINOS",
                slogan: "거침없이 가자 LIGHT, NOW!"
            )
            
        case .ssg:
            return TeamInfo(
                id: "SSG",
                shortName: "SSG",
                longName: "SSG 랜더스",
                englishFullName: "SSG LANDERS",
                slogan: "NO LIMITS, AMAZING LANDERS"
            )
            
        case .doosan:
            return TeamInfo(
                id: "DOOSAN",
                shortName: "두산",
                longName: "두산 베어스",
                englishFullName: "DOOSAN BEARS",
                slogan: "HUSTLE DOOGETHER"
            )
            
        case .kt:
            return TeamInfo(
                id: "KT",
                shortName: "KT",
                longName: "KT 위즈",
                englishFullName: "KT WIZ",
                slogan: "UP! GREAT KT"
            )
            
        case .kiwoom:
            return TeamInfo(
                id: "KIWOOM",
                shortName: "키움",
                longName: "키움 히어로즈",
                englishFullName: "KIWOOM HEROES",
                slogan: "도약 영웅의 서막"
            )
            
        case .kia:
            return TeamInfo(
                id: "KIA",
                shortName: "KIA",
                longName: "기아 타이거즈",
                englishFullName: "KIA TIGERS",
                slogan: "압도하라! V13 ALWAYS"
            )
        }
    }
    
    static func toAPICode(_ teamId: String) -> String? {
        let normalizedId = teamId.uppercased()
        
        switch normalizedId {
        case "DOOSAN": return "ob"
        case "HANWHA": return "hh"
        case "KIA": return "ht"
        case "KIWOOM": return "wo"
        case "KT": return "kt"
        case "LG": return "lg"
        case "LOTTE": return "lt"
        case "NC": return "nc"
        case "SAMSUNG": return "ss"
        case "SSG": return "sk"
        default: return nil
        }
    }
}
