//
//  WatchTeamRepositoryImpl.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

final class WatchTeamRepositoryImpl: WatchTeamRepository {

  private let defaults = UserDefaults.standard

  func fetchCurrentTeam() -> TeamInfo? {
    guard let teamId = defaults.string(forKey: WatchUserDefaultsKey.selectedTeamId) else { return nil }
    guard let teamCode = TeamDataSource.TeamCode(rawValue: teamId) else { return nil }
    return TeamDataSource.toEntity(teamCode)
  }

  func saveTeamId(_ teamId: String) {
    defaults.set(teamId, forKey: WatchUserDefaultsKey.selectedTeamId)
  }
}
