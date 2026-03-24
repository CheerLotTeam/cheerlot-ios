//
//  TeamPlayersSyncUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

protocol TeamPlayersSyncUseCase {
  /// 전체 선수 조회
  func getAllPlayers(_ teamId: TeamID) async throws -> [PlayerInfo]

  /// 전체 선수 동기화 (버전 확인 후 필요시만)
  func syncIfNeeded(_ teamId: TeamID) async throws

  /// 강제 전체 선수 동기화
  func forceSync(_ teamId: TeamID) async throws
}
