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

    // YYYY-MM-DD → M월 d일
    if let lastGameDate = gameInfo.lastGameDate {
      self.date = Self.formatDate(lastGameDate)
    } else {
      self.date = ""
    }

    if let opponentTeamInfo = opponentTeamInfo {
      self.opponent = opponentTeamInfo.shortName
    } else {
      self.opponent = nil
    }

    self.starterPitcher = gameInfo.starterPitcherName
    self.status = gameInfo.status
  }

  var gameInfoText: String {
    if let opponent = opponent {
      "\(date) | \(teamName) vs \(opponent)"
    } else {
      "\(date) | 경기없음"
    }
  }
  
  var gameDateText: String {
    date
  }

  var gameTeamsText: String {
    if let opponent = opponent {
      "\(teamName) vs \(opponent)"
    } else {
      "경기없음"
    }
  }

  // MARK: - Private
  private static func formatDate(_ dateString: String) -> String {
    // DateFormatter for parsing (YYYY-MM-DD)
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"

    guard let date = inputFormatter.date(from: dateString) else {
      return dateString
    }

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "M월 d일"
    outputFormatter.locale = Locale(identifier: "ko_KR")

    return outputFormatter.string(from: date)
  }
}
