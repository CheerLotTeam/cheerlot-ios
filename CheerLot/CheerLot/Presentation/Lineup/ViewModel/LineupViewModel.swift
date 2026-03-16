//
//  LineupViewModel.swift
//  CheerLot
//
//  Created by 이현주 on 2/5/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class LineupViewModel {
  // MARK: - State

  var lineupPlayers: [LineupPlayerVO] = []
  var gameInfo: LineupGameInfoVO?
  var asset: LineupAssetVO?

  var isLoading = false
  var errorMessage: String?
  var showToast = false
  var toastMessage = ""

  var showRecentLineup: Bool = false {
    didSet {
      userSettingsUseCase.setShowRecentLineup(showRecentLineup)
    }
  }

  var gameStatus: GameStatus {
    gameInfo?.status ?? .offDay
  }

  var shouldShowLineup: Bool {
    gameStatus == .playingToday || showRecentLineup
  }

  private var currentTeamId: String?

  // MARK: - Dependencies

  @ObservationIgnored
  @Injected(UserSettingsUseCase.self) private var userSettingsUseCase

  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  @ObservationIgnored
  @Injected(TeamInfoUseCase.self) private var teamInfoUseCase
    
 @ObservationIgnored
 @Injected(LineupManagementUseCase.self) private var lineupManagementUseCase

  // MARK: - Actions

  func onAppear() async {
    guard let teamInfo = teamSelectionUseCase.getCurrentTeam() else {
      errorMessage = "선택된 팀이 없습니다"
      return
    }
      
    currentTeamId = teamInfo.id.value

    await loadData()
    showRecentLineup = userSettingsUseCase.getShowRecentLineup()
  }
    
    func toggleShowRecentLineup() {
        showRecentLineup = true
    }
        
    func loadData() async {
        guard let teamId = currentTeamId else { return }
        
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let data = try await lineupManagementUseCase.loadLineup(for: TeamID(teamId))
            
            convertToVO(data: data, teamId: teamId)
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "데이터를 불러올 수 없습니다: \(error.userMessage)"
        }
    }
    
    func showNoSongToast() {
        toastMessage = "아직 개인 응원가가 없어요"
        showToast = true
    }
    
    // MARK: - Private
    private func convertToVO(data: LineupData, teamId: String) {
        guard let teamInfo = teamInfoUseCase.getTeamInfo(TeamID(teamId)) else {
            return
        }
        
        // 상대팀 정보 조회
        let opponentTeamInfo = data.opponentTeamId.flatMap {
            teamInfoUseCase.getTeamInfo($0)
        }
        
        // GameInfo VO 변환
        gameInfo = LineupGameInfoVO(
            teamInfo: teamInfo,
            opponentTeamInfo: opponentTeamInfo,
            gameInfo: data.gameInfo
        )
        
        // Lineup Players VO 변환
        lineupPlayers = data.lineupPlayers.map { LineupPlayerVO(from: $0) }
        
        // Asset 생성
        asset = LineupAssetVO(base: TeamAssetVO(TeamID(teamId)))
    }
}
