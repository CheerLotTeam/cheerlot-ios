//
//  TeamSelectionRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 2/10/26.
//

import Foundation

final class TeamSelectionRepositoryImpl: TeamSelectionRepository {

  private let sharedDefaults: UserDefaults

  init(appGroupIdentifier: String = "group.shared.CheerLot") {  // TODO: - config 처리
    guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
      fatalError("Failed to create UserDefaults with App Group")
    }
    self.sharedDefaults = defaults
  }

  func fetchCurrentTeam() -> TeamInfo? {
    // 1. UserDefaults에서 TeamID 가져오기
    guard let teamId = sharedDefaults.string(forKey: UserDefaultsKey.selectedTeamId) else { return nil }

    // 2. TeamCode로 변환
    guard let teamCode = TeamDataSource.TeamCode(rawValue: teamId) else { return nil }

    return TeamDataSource.toEntity(teamCode)
  }

  func updateSelectedTeam(_ teamId: TeamID) {
    sharedDefaults.set(teamId.value, forKey: UserDefaultsKey.selectedTeamId)
    sharedDefaults.set(true, forKey: UserDefaultsKey.hasSelectedTeam)

    NotificationCenter.default.post(
      name: .teamSelected,
      object: teamId
    )
  }

  func fetchHasSelectedTeam() -> Bool {
    sharedDefaults.bool(forKey: UserDefaultsKey.hasSelectedTeam)
  }

  func deleteSelectedTeam() {
    sharedDefaults.removeObject(forKey: UserDefaultsKey.selectedTeamId)
    sharedDefaults.set(false, forKey: UserDefaultsKey.hasSelectedTeam)
  }
}

extension Notification.Name {
  static let teamSelected = Notification.Name("teamSelected")
}
