//
//  WatchTeamRepository.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

/// Watch 로컬에 팀 정보를 저장/조회하는 Repository
protocol WatchTeamRepository {
  func fetchCurrentTeam() -> TeamInfo?
  func saveTeamId(_ teamId: String)
}
