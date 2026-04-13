//
//  TeamResponseDTO.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

struct TeamGameDTO: Decodable {
  let teamCode: String
  let isSeasonEnded: Bool
  let lastGameDate: String
  let hasTodayGame: Bool
  let opponentTeamCode: String?
  let starterPitcherName: String?
  let lineupUpdatedToday: Bool
}

struct TeamVersionsDTO: Decodable {
  let teamCode: String
  let playersVersion: Int
  let lineupVersion: Int
}

struct TeamGameScheduleDTO: Decodable {
  let teamCode: String
  let recentGames: [TeamRecentGameDTO]
}

struct TeamRecentGameDTO: Decodable {
  let date: String
  let hasGame: Bool
  let opponentTeamCode: String?
  let isHome: Bool?
  let starterPitcherName: String?
  let opponentStarterPitcherName: String?
}

extension TeamGameDTO {
  func toEntity() throws -> TeamGameInfo {
    let status: GameStatus

    if self.isSeasonEnded {
      status = .seasonEnded
    } else if self.hasTodayGame {
      status = .playingToday
    } else {
      status = .offDay
    }

    guard let code = TeamDataSource.fromAPICode(teamCode) else {
      throw LocalStorageError.invalidData
    }
    let teamId = TeamID(code.rawValue)

    let opponentTeamId: TeamID? = {
      guard let opponentCode = self.opponentTeamCode,
        let opponentTeamCode = TeamDataSource.fromAPICode(opponentCode)
      else { return nil }
      return TeamID(opponentTeamCode.rawValue)
    }()

    return TeamGameInfo(
      id: teamId,
      status: status,
      opponent: opponentTeamId,
      starterPitcherName: self.starterPitcherName,
      lastGameDate: self.lastGameDate,
      lineupUpdatedToday: self.lineupUpdatedToday
    )
  }
}

extension TeamVersionsDTO {
  func toEntity() -> TeamVersionInfo {
    return TeamVersionInfo(
      id: TeamID(self.teamCode),
      lineupVersion: self.lineupVersion,
      playersVersion: self.playersVersion
    )
  }
}

extension TeamGameScheduleDTO {
  func toEntity() throws -> TeamGameScheduleInfo {
    guard let code = TeamDataSource.fromAPICode(teamCode) else {
      throw LocalStorageError.invalidData
    }
    return TeamGameScheduleInfo(
      id: TeamID(code.rawValue),
      recentGames: self.recentGames.map { game in
        GameScheduleInfo(
          date: game.date,
          hasGame: game.hasGame,
          opponentTeamId: game.opponentTeamCode.flatMap { TeamDataSource.fromAPICode($0) }.map {
            TeamID($0.rawValue)
          },
          isHome: game.isHome,
          starterPitcherName: game.starterPitcherName,
          opponentStarterPitcherName: game.opponentStarterPitcherName
        )
      }
    )
  }
}
