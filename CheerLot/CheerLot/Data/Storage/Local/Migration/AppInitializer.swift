//
//  AppInitializer.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import SwiftData

@ModelActor
actor AppInitializer {

  /// 초기 팀 데이터 생성 (신규 설치 시)
  func initialize() async throws {
    try await createInitialTeamsIfNeeded()
  }

  private func createInitialTeamsIfNeeded() async throws {
    let descriptor = FetchDescriptor<Team>()
    let existingTeams = try modelContext.fetch(descriptor)

    guard existingTeams.isEmpty else {
      return  // 이미 팀이 있으면 스킵
    }

    try await createInitialTeams()
  }

  private func createInitialTeams() async throws {
    for code in TeamDataSource.TeamCode.allCases {
      let team = Team(
        teamId: code.rawValue,
        hasTodayGame: false,
        isSeasonEnded: false
      )
      modelContext.insert(team)
    }

    try modelContext.save()
  }
}
