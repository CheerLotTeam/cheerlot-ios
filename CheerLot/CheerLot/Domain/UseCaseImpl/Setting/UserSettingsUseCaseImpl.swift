//
//  UserSettingsUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

final class UserSettingsUseCaseImpl: UserSettingsUseCase {
  private let userSettingsRepository: UserSettingsRepository

  init(userSettingsRepository: UserSettingsRepository) {
    self.userSettingsRepository = userSettingsRepository
  }

  func getAppIconMode() -> AppIconMode {
    userSettingsRepository.getAppIconMode()
  }

  func setAppIconMode(_ mode: AppIconMode) {
    userSettingsRepository.setAppIconMode(mode)
  }
}
