//
//  TeamInfoRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import Foundation

final class TeamInfoRepositoryImpl: TeamInfoRepository {
  func fetchTeamInfo(_ teamId: TeamID) -> TeamInfo? {
    // 대소문자 무관하게 처리
    let normalizedId = teamId.value.uppercased()

    guard let teamCode = TeamDataSource.TeamCode(rawValue: normalizedId) else { return nil }

    return TeamDataSource.toEntity(teamCode)
  }

  func fetchAllTeamsInfo() -> [TeamInfo] {
    return TeamDataSource.TeamCode.allCases.map { code in
      TeamDataSource.toEntity(code)
    }
  }
}
