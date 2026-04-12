//
//  GameScheduleStorageDTO.swift
//  WidgetCheerLot
//
//  Created by 이현주 on 4/6/26.
//

import Foundation

struct GameScheduleStorageDTO: Codable {
  let teamId: String
  let recentGames: [GameScheduleItemStorageDTO]

  func toDomain() -> TeamGameScheduleInfo {
    TeamGameScheduleInfo(
      id: TeamID(teamId),
      recentGames: recentGames.map { $0.toDomain() }
    )
  }

  static func from(_ entity: TeamGameScheduleInfo) -> GameScheduleStorageDTO {
    GameScheduleStorageDTO(
      teamId: entity.id.value,
      recentGames: entity.recentGames.map { GameScheduleItemStorageDTO.from($0) }
    )
  }
}

struct GameScheduleItemStorageDTO: Codable {
  let date: String
  let hasGame: Bool
  let opponentTeamId: String?
  let isHome: Bool?
  let starterPitcherName: String?
  let opponentStarterPitcherName: String?

  func toDomain() -> GameScheduleInfo {
    GameScheduleInfo(
      date: date,
      hasGame: hasGame,
      opponentTeamId: opponentTeamId.map { TeamID($0) },
      isHome: isHome,
      starterPitcherName: starterPitcherName,
      opponentStarterPitcherName: opponentStarterPitcherName
    )
  }

  static func from(_ entity: GameScheduleInfo) -> GameScheduleItemStorageDTO {
    GameScheduleItemStorageDTO(
      date: entity.date,
      hasGame: entity.hasGame,
      opponentTeamId: entity.opponentTeamId?.value,
      isHome: entity.isHome,
      starterPitcherName: entity.starterPitcherName,
      opponentStarterPitcherName: entity.opponentStarterPitcherName
    )
  }
}
