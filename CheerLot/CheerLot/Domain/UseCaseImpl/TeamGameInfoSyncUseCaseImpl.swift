//
//  TeamGameInfoSyncUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

final class TeamGameInfoSyncUseCaseImpl: TeamGameInfoSyncUseCase {
    private let teamLocalRepository: TeamLocalRepository
    private let teamRemoteRepository: TeamRemoteRepository
    
    init(
        teamLocalRepository: TeamLocalRepository,
        teamRemoteRepository: TeamRemoteRepository
    ) {
        self.teamLocalRepository = teamLocalRepository
        self.teamRemoteRepository = teamRemoteRepository
    }
    
    func syncIfNeeded(teamId: TeamID) async throws {
        // 1. 서버 버전 확인
        let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)
        
        // 2. 로컬 버전 확인
        guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
            // 로컬에 없으면 무조건 동기화
            try await forceSync(teamId: teamId)
            return
        }
        
        // 3. 버전 비교 (lineupVersion 또는 playersVersion 중 하나라도 다르면 경기 정보도 바뀐 것)
        let hasVersionChanged = localTeam.versionInfo.lineupVersion != serverVersions.lineupVersion ||
        localTeam.versionInfo.playersVersion != serverVersions.playersVersion
        
        if hasVersionChanged {
            try await performSync(teamId: teamId)
        }
    }
    
    func forceSync(teamId: TeamID) async throws {
        try await performSync(teamId: teamId)
    }
    
    private func performSync(teamId: TeamID) async throws {
        // 1. 서버에서 최신 정보 가져오기
        let gameInfo = try await teamRemoteRepository.fetchGameInfo(teamId)
        let versionInfo = try await teamRemoteRepository.fetchVersions(teamId)
        
        // 2. TeamData 생성
        let teamData = TeamState(
            teamId: teamId,
            gameInfo: gameInfo,
            versionInfo: versionInfo
        )
        
        // 3. 로컬에 업데이트
        try await teamLocalRepository.updateTeam(teamData)
    }
}
