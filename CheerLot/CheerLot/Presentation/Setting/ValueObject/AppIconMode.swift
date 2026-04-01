//
//  AppIconMode.swift
//  CheerLot
//
//  Created by 이승진 on 3/14/26.
//

import Foundation

enum AppIconMode: String {
  case base
  case team

  var isTeamSelected: Bool {
    self == .team
  }
}
