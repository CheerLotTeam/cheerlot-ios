//
//  TeamSelectionRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 2/10/26.
//

import Foundation
import WidgetKit

final class TeamSelectionRepositoryImpl: TeamSelectionRepository {

  private let sharedDefaults: UserDefaults

  init(appGroupIdentifier: String = AppGroup.id) {
    guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
      fatalError("Failed to create UserDefaults with App Group")
    }
    self.sharedDefaults = defaults
  }

  func fetchCurrentTeam() -> TeamInfo? {
    // 1. UserDefaults에서 TeamID 가져오기
    guard let teamId = sharedDefaults.string(forKey: UserDefaultsKey.selectedTeamId) else {
      return nil
    }

    // 2. TeamCode로 변환
    guard let teamCode = TeamDataSource.TeamCode(rawValue: teamId) else { return nil }

    return TeamDataSource.toEntity(teamCode)
  }

  func updateSelectedTeam(_ teamId: TeamID) {
    sharedDefaults.set(teamId.value, forKey: UserDefaultsKey.selectedTeamId)
    sharedDefaults.set(true, forKey: UserDefaultsKey.hasSelectedTeam)
    resetWidgetGameState()
    WidgetCenter.shared.reloadAllTimelines()

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

extension TeamSelectionRepositoryImpl {
  // 팀 변경시 이전 팀 데이터 초기화
  private func resetWidgetGameState() {
    sharedDefaults.set(false, forKey: UserDefaultsKey.Widget.hasTodayGame)
    sharedDefaults.set(false, forKey: UserDefaultsKey.Widget.isSeasonEnded)
    sharedDefaults.removeObject(forKey: UserDefaultsKey.Widget.opponentTeamId)
  }
}

extension Notification.Name {
  static let teamSelected = Notification.Name("teamSelected")
}
