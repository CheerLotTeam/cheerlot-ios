//
//  LineupData.swift
//  CheerLot
//
//  Created by 이현주 on 3/15/26.
//

import Foundation

struct LineupData {
    let gameInfo: TeamGameInfo
    let lineupPlayers: [PlayerInfo]
    let opponentTeamId: TeamID?
}
