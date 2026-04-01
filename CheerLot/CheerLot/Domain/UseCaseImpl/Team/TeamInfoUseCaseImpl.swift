//
//  TeamInfoUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

import Foundation

final class TeamInfoUseCaseImpl: TeamInfoUseCase {

  private let teamInfoRepository: TeamInfoRepository

  init(teamInfoRepository: TeamInfoRepository) {
    self.teamInfoRepository = teamInfoRepository
  }

  func getTeamInfo(_ teamId: TeamID) -> TeamInfo? {
    teamInfoRepository.fetchTeamInfo(teamId)
  }

  func getAllTeamsInfo() -> [TeamInfo] {
    teamInfoRepository.fetchAllTeamsInfo()
  }
}
