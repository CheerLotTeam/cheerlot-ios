//
//  TeamSelectViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

import SwiftUI

@Observable
final class TeamSelectViewModel {
    var selectedTeam: TeamID?
    var teamList: [TeamInfo] = []
    var teamVOList: [TeamSelectVO] {
        teamList.map { TeamSelectVO(team: $0) }
    }
    var isButtonEnabled: Bool {
        selectedTeam != nil
    }
    var columns = [
        GridItem(.flexible(), spacing: 17),
        GridItem(.flexible(), spacing: 17)
    ]

    @ObservationIgnored
    @Injected(TeamInfoUseCase.self) private var teamInfoUseCase
    
    @ObservationIgnored
    @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase
    
    init() {
        loadTeams()
    }
    
    func loadTeams() {
        teamList = teamInfoUseCase.getAllTeamsInfo()
    }
    
    func select(_ id: TeamID) {
        selectedTeam = id
    }
    
    func complete() {
        guard let selectedTeam else { return }
        teamSelectionUseCase.selectTeam(selectedTeam)
        
        // TeamID -> TeamInfo 변환
        if let team = teamList.first(where: { $0.id == selectedTeam }) {
            NotificationCenter.default.post(name: .teamSelected, object: team)
        }
    }
}
