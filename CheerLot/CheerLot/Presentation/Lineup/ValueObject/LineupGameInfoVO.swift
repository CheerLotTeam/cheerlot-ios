//
//  LineupGameInfoVO.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

struct LineupGameInfoVO: Equatable {
  let teamName: String
  let teamEnglishName: String
  let date: String
  let opponent: String?
  let starterPitcher: String?
  let status: GameStatus

  init(
    teamInfo: TeamInfo,
    opponentTeamInfo: TeamInfo?,
    gameInfo: TeamGameInfo
  ) {
    self.teamName = teamInfo.shortName
    self.teamEnglishName = teamInfo.englishFullName
    self.date = gameInfo.lastGameDate.flatMap { Date.from(yyyyMMdd: $0)?.koreanDateFormatted } ?? ""
    self.opponent = opponentTeamInfo?.shortName
    self.starterPitcher = gameInfo.starterPitcherName
    self.status = gameInfo.status
  }

  var todayGameInfoText: String {
    "\(Date.now.koreanDateFormatted) | \(gameTeamsText)"
  }

  var gameDateText: String { date }

  var lastGameInfoText: String {
    "\(date) | \(gameTeamsText)"
  }

  var gameTeamsText: String {
    if let opponent = opponent {
      "\(teamName) vs \(opponent)"
    } else {
      "경기없음"
    }
  }
}
