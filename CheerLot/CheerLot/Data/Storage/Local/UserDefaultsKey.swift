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
  static let appIconMode = "appIconMode"
  static func lineupUpdatedToday(for teamId: TeamID) -> String {
    "lineupUpdatedToday.\(teamId.value)"
  }

  enum Widget {
    static let playerName = "widget.playerName"
    static let songTitle = "widget.songTitle"
    static let totalSongCount = "widget.totalSongCount"
    static let gameSchedule = "widget.gameSchedule"
  }
}

enum AppGroup {
  static let id = "group.shared.CheerLot"
}
