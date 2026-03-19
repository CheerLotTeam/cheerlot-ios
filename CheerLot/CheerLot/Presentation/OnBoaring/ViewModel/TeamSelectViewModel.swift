//
//  TeamSelectViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

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
    GridItem(.flexible(), spacing: 17)
  ]

  @ObservationIgnored
  @Injected(TeamInfoUseCase.self) private var teamInfoUseCase

  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

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
    teamSelectionUseCase.selectTeam(TeamID(selectedTeamId))
    NotificationCenter.default.post(name: .teamSelected, object: selectedTeamId)
  }
}
