//
//  LineupChangeUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

final class LineupChangeUseCaseImpl: LineupChangeUseCase {
    private let playerLocalRepository: PlayerLocalRepository
    
    init(playerLocalRepository: PlayerLocalRepository) {
        self.playerLocalRepository = playerLocalRepository
    }
    
    func getBenchPlayers(_ teamId: TeamID) async throws -> [PlayerInfo] {
        let allPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)
        
        return allPlayers
            .filter { $0.battingOrder == nil }
    }
    
    func swapPlayers(
        _ lineupPlayer: PlayerInfo,
        _ benchPlayer: PlayerInfo,
        _ teamId: TeamID
    ) async throws {
        // 검증
        guard lineupPlayer.battingOrder != nil else {
            throw LocalStorageError.invalidData
        }
        
        guard benchPlayer.battingOrder == nil else {
            throw LocalStorageError.invalidData
        }
        
        guard lineupPlayer.teamId == teamId && benchPlayer.teamId == teamId else {
            throw LocalStorageError.invalidData
        }
        
        // 타순 교환
        let lineupPlayerOrder = lineupPlayer.battingOrder!
        
        // 라인업 선수 → 벤치로 (타순 제거)
        let demotedPlayer = PlayerInfo(
            id: lineupPlayer.id,
            teamId: lineupPlayer.teamId,
            name: lineupPlayer.name,
            backNumber: lineupPlayer.backNumber,
            position: lineupPlayer.position,
            batThrow: lineupPlayer.batThrow,
            battingOrder: nil,
            cheerSongs: lineupPlayer.cheerSongs
        )
        try await playerLocalRepository.updatePlayer(demotedPlayer)
        
        // 벤치 선수 → 라인업으로 (타순 부여)
        let promotedPlayer = PlayerInfo(
            id: benchPlayer.id,
            teamId: benchPlayer.teamId,
            name: benchPlayer.name,
            backNumber: benchPlayer.backNumber,
            position: benchPlayer.position,
            batThrow: benchPlayer.batThrow,
            battingOrder: lineupPlayerOrder,
            cheerSongs: benchPlayer.cheerSongs
        )
        try await playerLocalRepository.updatePlayer(promotedPlayer)
    }
}
