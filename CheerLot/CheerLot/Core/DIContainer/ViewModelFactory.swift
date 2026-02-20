//
//  ViewModelFactory.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

final class ViewModelFactory {
    
    static let shared = ViewModelFactory()
    
    private init() {}
    
    // MARK: - Onboarding
    func createTeamSelectViewModel() -> TeamSelectViewModel {
        TeamSelectViewModel()
    }
    
    // MARK: - Lineup

    
    // MARK: - Playback
}
