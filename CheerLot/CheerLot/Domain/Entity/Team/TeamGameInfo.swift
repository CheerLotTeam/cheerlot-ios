//
//  TeamGameInfo.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

/// Team 경기 정보
struct TeamGameInfo: Identifiable, Hashable, Equatable {
  let id: TeamID
  var status: GameStatus
  var opponent: TeamID?
  var starterPitcherName: String?
  var lastGameDate: String?

  init(
    id: TeamID, status: GameStatus, opponent: TeamID? = nil, starterPitcherName: String? = nil,
    lastGameDate: String? = nil
  ) {
    self.id = id
    self.status = status
    self.opponent = opponent
    self.starterPitcherName = starterPitcherName
    self.lastGameDate = lastGameDate
  }
}

enum GameStatus {
  case playingToday
  case offDay
  case seasonEnded
}
