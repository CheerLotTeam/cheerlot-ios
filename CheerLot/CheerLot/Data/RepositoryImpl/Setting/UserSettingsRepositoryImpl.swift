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

  func getShowRecentLineup() -> Bool {
    sharedDefaults.bool(forKey: UserDefaultsKey.showRecentLineup)
  }

  func setShowRecentLineup(_ value: Bool) {
    sharedDefaults.set(value, forKey: UserDefaultsKey.showRecentLineup)
  }

  func resetShowRecentLineup() {
    sharedDefaults.set(false, forKey: UserDefaultsKey.showRecentLineup)
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
}
