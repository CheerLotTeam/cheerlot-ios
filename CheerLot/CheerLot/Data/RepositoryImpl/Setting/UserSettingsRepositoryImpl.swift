//
//  UserSettingsRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

final class UserSettingsRepositoryImpl: UserSettingsRepository {

  private let sharedDefaults: UserDefaults

  init(appGroupIdentifier: String = AppGroup.id) {
    guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
      fatalError("Failed to create UserDefaults with App Group")
    }
    self.sharedDefaults = defaults
  }

  func getAppIconMode() -> AppIconMode {
    guard
      let rawValue = sharedDefaults.string(forKey: UserDefaultsKey.appIconMode),
      let mode = AppIconMode(rawValue: rawValue)
    else {
      return .base
    }
    return mode
  }

  func setAppIconMode(_ mode: AppIconMode) {
    sharedDefaults.set(mode.rawValue, forKey: UserDefaultsKey.appIconMode)
  }

  func getLineupUpdatedToday(for teamId: TeamID) -> Bool {
    sharedDefaults.bool(forKey: UserDefaultsKey.lineupUpdatedToday(for: teamId))
  }

  func setLineupUpdatedToday(_ value: Bool, for teamId: TeamID) {
    sharedDefaults.set(value, forKey: UserDefaultsKey.lineupUpdatedToday(for: teamId))
  }

  func getLineupIsHome(for teamId: TeamID) -> Bool? {
    sharedDefaults.object(forKey: "lineupIsHome.\(teamId.value)") as? Bool
  }

  func setLineupIsHome(_ value: Bool?, for teamId: TeamID) {
    if let value {
      sharedDefaults.set(value, forKey: "lineupIsHome.\(teamId.value)")
    } else {
      sharedDefaults.removeObject(forKey: "lineupIsHome.\(teamId.value)")
    }
  }
}
