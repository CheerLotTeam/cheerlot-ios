//
//  TeamGameInfoUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/25/26.
//

import Foundation

final class TeamGameInfoUseCaseImpl: TeamGameInfoUseCase {
  private let teamLocalRepository: TeamLocalRepository

  init(teamLocalRepository: TeamLocalRepository) {
    self.teamLocalRepository = teamLocalRepository
  }

  func isGameDay(_ teamId: TeamID) async -> Bool {
    let state = try? await teamLocalRepository.fetchTeam(teamId)
    return state?.gameInfo.status == .playingToday
  }
}
