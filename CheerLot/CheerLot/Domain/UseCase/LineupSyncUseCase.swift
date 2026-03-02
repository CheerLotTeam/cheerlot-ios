//
//  LineupSyncUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

protocol LineupSyncUseCase {
    /// 라인업 동기화 (버전 확인 후 필요시만)
    func syncIfNeeded(teamId: TeamID) async throws
    
    /// 강제 라인업 동기화
    func forceSync(teamId: TeamID) async throws
}
