//
//  TeamSelectionUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 2/10/26.
//

import Foundation

final class TeamSelectionUseCaseImpl: TeamSelectionUseCase {
    
    let teamSelectionRepository: TeamSelectionRepository
    
    init(teamSelectionRepository: TeamSelectionRepository) {
        self.teamSelectionRepository = teamSelectionRepository
    }
    
    func getCurrentTeam() throws -> TeamInfo {
        try teamSelectionRepository.fetchCurrentTeam()
    }
    
    func selectTeam(_ team: TeamInfo) async throws {
        try await teamSelectionRepository.updateSelectedTeam(team)
    }
    
    func changeTeam(_ team: TeamInfo) async throws {
        try await teamSelectionRepository.updateSelectedTeam(team)
    }
    
    func hasSelectedTeam() -> Bool {
        teamSelectionRepository.fetchHasSelectedTeam()
    }
}
