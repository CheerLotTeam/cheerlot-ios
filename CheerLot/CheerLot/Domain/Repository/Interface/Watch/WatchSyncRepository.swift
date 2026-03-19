//
//  WatchSyncRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

/// iPhone → Watch 데이터 동기화 Repository
protocol WatchSyncRepository {
  /// 선택된 팀 ID를 Watch로 전송
  func sendTeamSelection(_ teamId: TeamID)

  /// 현재 라인업 선수 목록을 Watch로 전송
  func sendLineup(_ players: [PlayerInfo])
}
