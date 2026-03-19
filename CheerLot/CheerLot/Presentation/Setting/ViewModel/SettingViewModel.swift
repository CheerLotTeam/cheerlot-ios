//
//  SettingViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class SettingViewModel {

  // MARK: - State
  var currentTeam: TeamInfo
  var appIconMode: AppIconMode

  // MARK: - Dependencies
  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  @ObservationIgnored
  @Injected(UserSettingsUseCase.self) private var userSettingsUseCase

  // MARK: - Init
  init() {
    let teamSelectionUseCase = DIContainer.shared.resolve(TeamSelectionUseCase.self)
    let userSettingsUseCase = DIContainer.shared.resolve(UserSettingsUseCase.self)

    self.currentTeam =
      teamSelectionUseCase.getCurrentTeam()
      ?? TeamDataSource.toEntity(.samsung)

    self.appIconMode = userSettingsUseCase.getAppIconMode()
  }

  // MARK: - Lifecycle
  func onAppear() {
    if let team = teamSelectionUseCase.getCurrentTeam(),
      team.id != currentTeam.id
    {
      currentTeam = team
    }

    let savedMode = userSettingsUseCase.getAppIconMode()
    if savedMode != appIconMode {
      appIconMode = savedMode
    }
  }

  // MARK: - Setting Actions
  func didUpdateSelectedTeam() {
    guard let team = teamSelectionUseCase.getCurrentTeam() else { return }
    currentTeam = team

    if appIconMode == .team {
      applyCurrentAppIcon()
    }
  }

  func didSelectAppIconMode(_ mode: AppIconMode) {
    appIconMode = mode
    userSettingsUseCase.setAppIconMode(mode)
    applyCurrentAppIcon()
  }

  // MARK: - Private
  private func applyCurrentAppIcon() {
    guard UIApplication.shared.supportsAlternateIcons else {
      print("Alternate app icons are not supported on this device.")
      return
    }

    let targetIconName: String? = {
      switch appIconMode {
      case .base:
        return nil
      case .team:
        return AppIconVO.iconName(for: currentTeam.id)
      }
    }()

    guard UIApplication.shared.alternateIconName != targetIconName else {
      return
    }

    UIApplication.shared.setAlternateIconName(targetIconName) { error in
      if let error {
        print("App icon change failed: \(error.localizedDescription)")
      }
    }
  }
}
