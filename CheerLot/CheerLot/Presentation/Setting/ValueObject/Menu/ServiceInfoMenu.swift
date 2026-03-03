//
//  ServiceInfoMenu.swift
//  CheerLot
//
//  Created by 이승진 on 3/3/26.
//

import SwiftUI

enum ServiceInfoMenu: String, CaseIterable, Identifiable {
  case mainPage = "대표 페이지"

  case termsOfService = "이용약관"
  case privacyPolicy = "개인정보처리방침"
  case copyright = "저작권 법적고지"

  var id: String { self.rawValue }
}
