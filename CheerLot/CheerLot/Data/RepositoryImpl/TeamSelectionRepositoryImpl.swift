//
//  TeamSelectionRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 2/10/26.
//

import Foundation

final class TeamSelectionRepositoryImpl: TeamSelectionRepository {
    
    private let sharedDefaults: UserDefaults
    
    private enum Keys {
        static let selectedTeamId = "selectedTeamId"
        static let hasSelectedTeam = "hasSelectedTeam"
    }
    
    init(appGroupIdentifier: String = "group.com.CheerLot") { // TODO: - config 처리
        guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
            fatalError("Failed to create UserDefaults with App Group")
        }
        self.sharedDefaults = defaults
    }
    
    func fetchCurrentTeam() throws -> TeamInfo {
        // 1. UserDefaults에서 TeamID 가져오기
        guard let teamId = sharedDefaults.string(forKey: Keys.selectedTeamId) else {
            throw RepositoryError.notFound
        }
        
        // 2. TeamCode로 변환
        guard let teamCode = TeamDataSource.TeamCode(rawValue: teamId) else {
            throw RepositoryError.invalidData
        }
        
        return TeamDataSource.toEntity(teamCode)
    }
    
    func updateSelectedTeam(_ team: TeamInfo) async throws {
        sharedDefaults.set(team.id.value, forKey: Keys.selectedTeamId)
        sharedDefaults.set(true, forKey: Keys.hasSelectedTeam)
        sharedDefaults.synchronize()
        
        NotificationCenter.default.post(
            name: .teamSelected,
            object: team
        )
    }
    
    func fetchHasSelectedTeam() -> Bool {
        sharedDefaults.bool(forKey: Keys.hasSelectedTeam)
    }
    
    func deleteSelectedTeam() {
        sharedDefaults.removeObject(forKey: Keys.selectedTeamId)
        sharedDefaults.set(false, forKey: Keys.hasSelectedTeam)
        sharedDefaults.synchronize()
    }
}

extension Notification.Name {
    static let teamSelected = Notification.Name("teamSelected")
}
