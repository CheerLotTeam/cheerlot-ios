//
//  TeamRemoteRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

protocol TeamRemoteRepository {
  /// 팀 경기 정보 조회
  func fetchGameInfo(_ teamId: TeamID) async throws -> TeamGameInfo

  /// 팀 라인업, 전체선수 버전 정보 조회
  func fetchVersions(_ teamId: TeamID) async throws -> TeamVersionInfo
}
