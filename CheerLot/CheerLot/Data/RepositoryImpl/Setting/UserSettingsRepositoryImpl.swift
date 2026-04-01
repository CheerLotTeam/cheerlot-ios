//
//  UserSettingsRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

final class UserSettingsRepositoryImpl: UserSettingsRepository {

  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  func getShowRecentLineup() -> Bool {
    userDefaults.bool(forKey: UserDefaultsKey.showRecentLineup)
  }

  func setShowRecentLineup(_ value: Bool) {
    userDefaults.set(value, forKey: UserDefaultsKey.showRecentLineup)
  }

  func resetShowRecentLineup() {
    userDefaults.set(false, forKey: UserDefaultsKey.showRecentLineup)
  }

  func getAppIconMode() -> AppIconMode {
    guard
      let rawValue = userDefaults.string(forKey: UserDefaultsKey.appIconMode),
      let mode = AppIconMode(rawValue: rawValue)
    else {
      return .base
    }
    return mode
  }

  func setAppIconMode(_ mode: AppIconMode) {
    userDefaults.set(mode.rawValue, forKey: UserDefaultsKey.appIconMode)
  }
}
