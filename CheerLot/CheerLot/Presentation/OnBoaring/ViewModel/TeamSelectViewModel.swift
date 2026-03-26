//
//  TeamSelectViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

import Observation
import SwiftUI

@Observable
final class TeamSelectViewModel {
  var teams: [TeamSelectVO] = []
  var selectedTeamId: String?
  let mode: TeamSelectMode

  var isButtonEnabled: Bool {
    selectedTeamId != nil
  }

  let columns = [
    GridItem(.flexible(), spacing: 17),
    GridItem(.flexible(), spacing: 17),
  ]

  @ObservationIgnored
  @Injected(TeamInfoUseCase.self) private var teamInfoUseCase

  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  @ObservationIgnored
  @Injected(AudioPlaybackUseCase.self) private var audioPlaybackUseCase

  @ObservationIgnored
  @Injected(AnalyticsService.self) private var analyticsService

  init(
    mode: TeamSelectMode,
    initialSelectedTeamId: String? = nil
  ) {
    self.mode = mode
    self.selectedTeamId = initialSelectedTeamId
    loadTeams()
  }

  func loadTeams() {
    let teamEntities = teamInfoUseCase.getAllTeamsInfo()
    teams = teamEntities.map { TeamSelectVO(from: $0) }
  }

  func select(_ teamId: String) {
    selectedTeamId = teamId
  }

  func complete() {
    guard let selectedTeamId = selectedTeamId else { return }

    audioPlaybackUseCase.stop()
    teamSelectionUseCase.selectTeam(TeamID(selectedTeamId))
    analyticsService.setUserProperty(.teamId, value: selectedTeamId)
    NotificationCenter.default.post(name: .teamSelected, object: selectedTeamId)
  }
}
