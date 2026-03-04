//
//  UserSettingsUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

final class UserSettingsUseCaseImpl: UserSettingsUseCase {
    private let userSettingsRepository: UserSettingsRepository
    
    init(userSettingsRepository: UserSettingsRepository) {
        self.userSettingsRepository = userSettingsRepository
    }

    func getShowRecentLineup() -> Bool {
        userSettingsRepository.getShowRecentLineup()
    }
    
    func setShowRecentLineup(_ value: Bool) {
        userSettingsRepository.setShowRecentLineup(value)
    }
    
    func resetShowRecentLineup() {
        userSettingsRepository.resetShowRecentLineup()
    }
}
