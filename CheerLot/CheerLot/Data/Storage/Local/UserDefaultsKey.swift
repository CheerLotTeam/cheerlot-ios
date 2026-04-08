//
//  UserDefaultsKey.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

enum UserDefaultsKey {
  static let selectedTeamId = "selectedTeamId"
  static let hasSelectedTeam = "hasSelectedTeam"
  static let showRecentLineup = "showRecentLineup"
  static let appIconMode = "appIconMode"

  enum Widget {
    static let playerName = "widget.playerName"
    static let totalSongCount = "widget.totalSongCount"
    static let gameSchedule = "widget.gameSchedule"
  }
}

enum AppGroup {
  static let id = "group.shared.CheerLot"
}
