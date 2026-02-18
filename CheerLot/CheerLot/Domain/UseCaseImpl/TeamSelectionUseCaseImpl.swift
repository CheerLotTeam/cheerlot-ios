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
    
    func getCurrentTeam() -> TeamInfo? {
        teamSelectionRepository.fetchCurrentTeam()
    }
    
    func selectTeam(_ teamId: TeamID) {
        teamSelectionRepository.updateSelectedTeam(teamId)
    }
    
    func changeTeam(_ teamId: TeamID) {
        teamSelectionRepository.updateSelectedTeam(teamId)
    }
    
    func hasSelectedTeam() -> Bool {
        teamSelectionRepository.fetchHasSelectedTeam()
    }
}
