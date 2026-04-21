//
//  TeamGameScheduleInfo.swift
//  CheerLot
//
//  Created by 이현주 on 4/5/26.
//

import Foundation

struct TeamGameScheduleInfo {
  let id: TeamID
  var recentGames: [GameScheduleInfo]
}

struct GameScheduleInfo {
  let date: String
  let hasGame: Bool
  var opponentTeamId: TeamID?
  var isHome: Bool?
  var starterPitcherName: String?
  var opponentStarterPitcherName: String?
}
