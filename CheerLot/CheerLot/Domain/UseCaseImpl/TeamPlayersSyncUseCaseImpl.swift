//
//  TeamPlayersSyncUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

final class TeamPlayersSyncUseCaseImpl: TeamPlayersSyncUseCase {
    private let teamLocalRepository: TeamLocalRepository
    private let teamRemoteRepository: TeamRemoteRepository
    private let playerLocalRepository: PlayerLocalRepository
    private let playerRemoteRepository: PlayerRemoteRepository
    
    init(
        teamLocalRepository: TeamLocalRepository,
        teamRemoteRepository: TeamRemoteRepository,
        playerLocalRepository: PlayerLocalRepository,
        playerRemoteRepository: PlayerRemoteRepository
    ) {
        self.teamLocalRepository = teamLocalRepository
        self.teamRemoteRepository = teamRemoteRepository
        self.playerLocalRepository = playerLocalRepository
        self.playerRemoteRepository = playerRemoteRepository
    }
    
    func getAllPlayers(teamId: TeamID) async throws -> [PlayerInfo] {
        try await playerLocalRepository.fetchAllPlayers(teamId)
    }
    
    func syncIfNeeded(teamId: TeamID) async throws {
        // 서버 버전 확인
        let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)
        
        // 로컬 버전 확인
        guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
            // 로컬에 없으면 무조건 동기화
            try await forceSync(teamId: teamId)
            return
        }
        
        // 버전 비교
        if localTeam.versionInfo.playersVersion != serverVersions.playersVersion {
            try await performSync(teamId: teamId, newVersion: serverVersions.playersVersion)
        }
    }
    
    func forceSync(teamId: TeamID) async throws {
        let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)
        try await performSync(teamId: teamId, newVersion: serverVersions.playersVersion)
    }
    
    // MARK: - Private Method
    
    private func performSync(teamId: TeamID, newVersion: Int) async throws {
        // 서버에서 전체 선수 가져오기
        let allPlayers = try await playerRemoteRepository.fetchAllPlayers(teamId)
        
        // 로컬 전체 삭제
        try await playerLocalRepository.deleteAllPlayers(teamId)
        
        // 새로 저장
        try await playerLocalRepository.createAllPlayers(allPlayers, teamId)
        
        // 팀 버전 업데이트
        try await updatePlayersVersion(teamId: teamId, version: newVersion)
    }
    
    private func updatePlayersVersion(teamId: TeamID, version: Int) async throws {
        guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
            throw LocalStorageError.notFound
        }
        
        let updatedVersionInfo = TeamVersionInfo(
            id: teamId,
            lineupVersion: localTeam.versionInfo.lineupVersion,
            playersVersion: version
        )
        
        let updatedTeam = TeamState(
            teamId: teamId,
            gameInfo: localTeam.gameInfo,
            versionInfo: updatedVersionInfo
        )
        
        try await teamLocalRepository.updateTeam(updatedTeam)
    }
}
