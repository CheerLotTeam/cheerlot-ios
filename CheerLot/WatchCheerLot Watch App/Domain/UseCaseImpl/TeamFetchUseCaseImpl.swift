//
//  TeamFetchUseCaseImpl.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

final class TeamFetchUseCaseImpl: TeamFetchUseCase {

  private let watchTeamRepository: WatchTeamRepository

  init(watchTeamRepository: WatchTeamRepository) {
    self.watchTeamRepository = watchTeamRepository
  }

  func getCurrentTeam() -> TeamInfo? {
    watchTeamRepository.fetchCurrentTeam()
  }
}
