//
//  LineupSyncUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

protocol LineupSyncUseCase {
  /// 현재 라인업 조회 (타순 있는 선수 9명)
  func getCurrentLineup(_ teamId: TeamID) async throws -> [PlayerInfo]

  /// 라인업 동기화 (버전 확인 후 필요시만)
  func syncIfNeeded(_ teamId: TeamID) async throws

  /// 강제 라인업 동기화
  func forceSync(_ teamId: TeamID) async throws
}
