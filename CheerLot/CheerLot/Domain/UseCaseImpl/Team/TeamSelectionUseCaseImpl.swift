//
//  TeamSelectionUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 2/10/26.
//

import Foundation
import WidgetKit

final class TeamSelectionUseCaseImpl: TeamSelectionUseCase {

  private let teamSelectionRepository: TeamSelectionRepository

  init(teamSelectionRepository: TeamSelectionRepository) {
    self.teamSelectionRepository = teamSelectionRepository
  }

  func getCurrentTeam() -> TeamInfo? {
    teamSelectionRepository.fetchCurrentTeam()
  }

  func selectTeam(_ teamId: TeamID) {
    teamSelectionRepository.updateSelectedTeam(teamId)
    WidgetCenter.shared.reloadAllTimelines()
  }

  func changeTeam(_ teamId: TeamID) {
    teamSelectionRepository.updateSelectedTeam(teamId)
    WidgetCenter.shared.reloadAllTimelines()
  }

  func hasSelectedTeam() -> Bool {
    teamSelectionRepository.fetchHasSelectedTeam()
  }
}
