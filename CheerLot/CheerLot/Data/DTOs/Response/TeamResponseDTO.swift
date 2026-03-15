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
  func toEntity() -> TeamGameInfo {
    let status: GameStatus

    if self.isSeasonEnded {
      status = .seasonEnded
    } else if self.hasTodayGame {
      status = .playingToday
    } else {
      status = .offDay
    }
      
      let teamId: TeamID = {
          let teamCode = TeamDataSource.fromAPICode(self.teamCode)
          return TeamID(teamCode.rawValue)
      }()
      
      let opponentTeamId: TeamID? = {
          guard let opponentCode = self.opponentTeamCode else { return nil }
          let opponentTeamCode = TeamDataSource.fromAPICode(opponentCode)
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
