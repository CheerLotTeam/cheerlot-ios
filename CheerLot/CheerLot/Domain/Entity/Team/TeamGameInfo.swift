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
  var lineupUpdatedToday: Bool

  init(
    id: TeamID,
    status: GameStatus,
    opponent: TeamID? = nil,
    starterPitcherName: String? = nil,
    lastGameDate: String? = nil,
    lineupUpdatedToday: Bool
  ) {
    self.id = id
    self.status = status
    self.opponent = opponent
    self.starterPitcherName = starterPitcherName
    self.lastGameDate = lastGameDate
    self.lineupUpdatedToday = lineupUpdatedToday
  }
}

enum GameStatus {
  case playingToday    // 오늘 경기 있고 라인업 준비됨
  case lineupPending   // 오늘 경기 있고 라인업 준비중
  case offDay
  case seasonEnded
}
