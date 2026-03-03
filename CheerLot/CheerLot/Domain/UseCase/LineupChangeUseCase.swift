//
//  LineupChangeUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

protocol LineupChangeUseCase {
    /// 벤치 선수 조회 (타순 없는 선수들)
    func getBenchPlayers(teamId: TeamID) async throws -> [PlayerInfo]
    
    /// 라인업 선수와 벤치 선수 교체
    func swapPlayers(
        lineupPlayer: PlayerInfo,
        benchPlayer: PlayerInfo,
        teamId: TeamID
    ) async throws
}
