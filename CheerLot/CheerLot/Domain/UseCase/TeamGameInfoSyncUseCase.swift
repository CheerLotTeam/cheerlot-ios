//
//  TeamGameInfoSyncUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

protocol TeamGameInfoSyncUseCase {
    /// 경기 정보 조회
    func getGameInfo(teamId: TeamID) async throws -> TeamGameInfo
    
    /// 경기 정보 동기화 (버전 확인 후 필요시만)
    func syncIfNeeded(teamId: TeamID) async throws
    
    /// 강제 경기 정보 동기화
    func forceSync(teamId: TeamID) async throws
}
