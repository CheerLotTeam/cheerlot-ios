//
//  TeamGamesEntry.swift
//  CheerLot
//
//  Created by 이현주 on 4/6/26.
//

import WidgetKit

struct TeamGamesEntry: TimelineEntry {
  let date: Date
  let teamId: String
  let teamShortName: String
  let teamLongName: String
  let gameSchedule: [Game]
  let gameStatus: WidgetGameStatus
}

enum WidgetGameStatus: Equatable {
  case teamEmpty
  case playingToday
  case offDay
  case seasonEnded
}

struct Game {
  let date: Date
  let hasGame: Bool
  let starterPitcherName: String?
  let opponentId: String?
  let opponentShortName: String?
  let opponentLongName: String?
  let isHome: Bool?
}

// MARK: - Preview Entries

extension TeamGamesEntry {
  static let preview = TeamGamesEntry(
    date: .now,
    teamId: "SAMSUNG",
    teamShortName: "삼성",
    teamLongName: "삼성 라이온즈",
    gameSchedule: [
      Game(
        date: .now,
        hasGame: true,
        starterPitcherName: "원태인",
        opponentId: "HANWHA",
        opponentShortName: "한화",
        opponentLongName: "한화 이글스",
        isHome: true
      ),
      Game(
        date: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
        hasGame: false,
        starterPitcherName: nil,
        opponentId: nil,
        opponentShortName: nil,
        opponentLongName: nil,
        isHome: nil
      ),
      Game(
        date: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
        hasGame: true,
        starterPitcherName: "후라도",
        opponentId: "LG",
        opponentShortName: "LG",
        opponentLongName: "LG 트윈스",
        isHome: false
      ),
    ],
    gameStatus: .playingToday
  )

  static let fallback = TeamGamesEntry(
    date: .now,
    teamId: "",
    teamShortName: "",
    teamLongName: "",
    gameSchedule: [],
    gameStatus: .teamEmpty
  )
}
