//
//  TeamRemoteRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

protocol TeamRemoteRepository {
  /// 팀의 시즌 상태와 오늘 경기 정보 조회
  func fetchTodayGameInfo(_ teamId: TeamID) async throws -> TeamGameInfo

  /// 팀 라인업, 전체선수 버전 정보 조회
  func fetchVersions(_ teamId: TeamID) async throws -> TeamVersionInfo

  /// 팀의 3일간 경기 일정을 조회
  func fetchGamesSchedule(_ teamId: TeamID) async throws -> TeamGameScheduleInfo
}
