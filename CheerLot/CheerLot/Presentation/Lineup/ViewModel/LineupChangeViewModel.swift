//
//  LineupChangeViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class LineupChangeViewModel {
    // MARK: - State
    let columns = [
      GridItem(.flexible(), spacing: 23),
      GridItem(.flexible(), spacing: 23),
    ]
    let lineupPlayer: LineupPlayerVO // 교체될 선수
    var benchPlayers: [LineupPlayerVO] = []
    var selectedPlayer: LineupPlayerVO? // 교체할 선수
    var asset: LineupChangeAssetVO?
    
    var isLoading = false
    var errorMessage: String?
    var isSwapping = false
    
    var canSwap: Bool {
        selectedPlayer != nil && !isSwapping
    }
    
    private let teamId: String
    
    // MARK: - Dependencies
    @ObservationIgnored
    @Injected(LineupChangeUseCase.self) private var lineupChangeUseCase
    
    @ObservationIgnored
    @Injected(TeamInfoUseCase.self) private var teamInfoUseCase
    
    // MARK: - Init
    init(_ lineupPlayer: LineupPlayerVO) {
        self.lineupPlayer = lineupPlayer
        self.teamId = lineupPlayer.teamId
        self.asset = LineupChangeAssetVO(base: TeamAssetVO(TeamID(teamId)))
    }
    
    // MARK: - Actions
    
    func onAppear() async {
        await loadBenchPlayers()
    }
    
    func selectPlayer(_ player: LineupPlayerVO) {
        if selectedPlayer?.id == player.id {
            selectedPlayer = nil
        } else {
            selectedPlayer = player
        }
    }
    
    func isSelected(_ player: LineupPlayerVO) -> Bool {
        selectedPlayer?.id == player.id
    }
    
    func swapPlayers() async -> Bool {
        guard let selectedPlayer = selectedPlayer else {
            errorMessage = "교체할 선수를 선택해주세요"
            return false
        }
        
        isSwapping = true
        errorMessage = nil
        
        do {
            let lineupPlayerEntity = lineupPlayer.toEntity()
            let benchPlayerEntity = selectedPlayer.toEntity()
            
            try await lineupChangeUseCase.swapPlayers(
                lineupPlayerEntity,
                benchPlayerEntity,
                TeamID(teamId)
            )
            
            isSwapping = false
            return true
            
        } catch {
            isSwapping = false
            errorMessage = "선수 교체 실패: \(error.localizedDescription)"
            return false
        }
    }
    
    // MARK: - Private
    
    private func loadBenchPlayers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let benchEntities = try await lineupChangeUseCase.getBenchPlayers(TeamID(teamId))
            
            benchPlayers = benchEntities.map { LineupPlayerVO(from: $0) }
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "벤치 선수를 불러올 수 없습니다: \(error.localizedDescription)"
        }
    }
}
