//
//  TeamResponseDTO.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

struct TeamMatchInfoDTO: Decodable {
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
