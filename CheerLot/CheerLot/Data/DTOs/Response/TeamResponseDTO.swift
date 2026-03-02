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
        
        return TeamGameInfo(
            id: TeamID(self.teamCode),
            status: status,
            opponent: self.opponentTeamCode.map { TeamID($0) },
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

