//
//  TeamSelectMode.swift
//  CheerLot
//
//  Created by 이승진 on 3/12/26.
//

import Foundation

enum TeamSelectMode {
  case onboarding
  case change

  var guideText: String {
    "응원 팀을 선택해주세요"
  }

  var showsTopBar: Bool {
    switch self {
    case .onboarding: return false
    case .change: return true
    }
  }

  var showsBottomButton: Bool {
    switch self {
    case .onboarding: return true
    case .change: return false
    }
  }

  var navigationTitle: String {
    switch self {
    case .onboarding: return ""
    case .change: return "팀 변경"
    }
  }
}
