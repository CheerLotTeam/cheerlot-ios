//
//  SupportInfoMenu.swift
//  CheerLot
//
//  Created by 이승진 on 3/3/26.
//

import Foundation

enum SupportInfoMenu: String, CaseIterable, Identifiable {
  case serviceIntro = "서비스 소개"
  case cheerlotTeam = "쳐랏 팀"
  case reportBug = "문의하기"

  var id: String { self.rawValue }
}
