//
//  AppIconVO.swift
//  CheerLot
//
//  Created by 이승진 on 3/14/26.
//

import Foundation

enum AppIconVO {
  static func iconName(for teamID: TeamID) -> String {
    let apiCode = TeamDataSource.toAPICode(teamID)
    return "cheerlot_icon_\(apiCode)"
  }
}
