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
    static let hasTodayGame = "widget.hasTodayGame"
    static let isSeasonEnded = "widget.isSeasonEnded"
    static let opponentTeamId = "widget.opponentTeamId"
    static let playerName = "widget.playerName"
    static let totalSongCount = "widget.totalSongCount"
  }
}

enum AppGroup {
  static let id = "group.shared.CheerLot"
}
