//
//  PlayerRemoteRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

protocol PlayerRemoteRepository {
  /// 팀 라인업 조회
  func fetchLineup(_ teamId: TeamID) async throws -> [PlayerInfo]

  /// 특정 선수 조회
  func fetchPlayer(_ playerId: PlayerID) async throws -> PlayerInfo

  /// 팀 전체 선수 조회
  func fetchAllPlayers(_ teamId: TeamID) async throws -> [PlayerInfo]
}
