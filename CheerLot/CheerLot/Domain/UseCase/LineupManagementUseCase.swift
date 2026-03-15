//
//  LineupManagementUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/14/26.
//

import Foundation

/// 라인업 데이터 관리 (동기화 + 조회)
protocol LineupManagementUseCase {
    /// 라인업 데이터 로드 (필요시 동기화)
    func loadLineup(for teamId: TeamID) async throws -> LineupData
    
    /// 강제 새로고침
    func refreshLineup(for teamId: TeamID) async throws -> LineupData
}
