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
}

struct TeamVersionsDTO: Decodable {
  let teamCode: String
  let playersVersion: Int
  let lineupVersion: Int
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
      lastGameDate: self.lastGameDate
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
