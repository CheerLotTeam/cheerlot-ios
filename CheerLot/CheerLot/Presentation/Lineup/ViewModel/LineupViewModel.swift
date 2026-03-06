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
  @Injected(TeamGameInfoSyncUseCase.self) private var teamGameInfoSyncUseCase

  @ObservationIgnored
  @Injected(LineupSyncUseCase.self) private var lineupSyncUseCase

  @ObservationIgnored
  @Injected(TeamPlayersSyncUseCase.self) private var teamPlayersSyncUseCase

  // MARK: - Actions

  func onAppear() async {
    guard let teamInfo = teamSelectionUseCase.getCurrentTeam() else {
      errorMessage = "선택된 팀이 없습니다"
      return
    }
    currentTeamId = teamInfo.id.value

    await syncData()
    showRecentLineup = userSettingsUseCase.getShowRecentLineup()
    await loadData()
  }

  func refresh() async {
    await syncData()
    showRecentLineup = userSettingsUseCase.getShowRecentLineup()
    await loadData()
  }

  func toggleShowRecentLineup() {
    showRecentLineup = true
  }

  // MARK: - Private

  private func loadData() async {
    isLoading = true
    errorMessage = nil

    do {
      // 현재 팀 조회
      guard let teamInfo = teamSelectionUseCase.getCurrentTeam() else {
        throw LocalStorageError.notFound
      }

      // 경기 정보 조회
      let gameInfoEntity = try await teamGameInfoSyncUseCase.getGameInfo(teamInfo.id)

      // 상대팀 TeamInfo 조회
      let opponentTeamInfo: TeamInfo?
      if let opponentTeamId = gameInfoEntity.opponent {
        opponentTeamInfo = teamInfoUseCase.getTeamInfo(opponentTeamId)
      } else {
        opponentTeamInfo = nil
      }

      // GameInfo VO 변환
      gameInfo = LineupGameInfoVO(
        teamInfo: teamInfo,
        opponentTeamInfo: opponentTeamInfo,
        gameInfo: gameInfoEntity
      )

      // 라인업 조회 및 VO 변환
      let lineupEntities = try await lineupSyncUseCase.getCurrentLineup(teamInfo.id)
      lineupPlayers = lineupEntities.map { LineupPlayerVO(from: $0) }

      // Asset 생성
      asset = LineupAssetVO(base: TeamAssetVO(teamInfo.id))

      isLoading = false
    } catch {
      isLoading = false
      errorMessage = "데이터를 불러올 수 없습니다: \(error.localizedDescription)"
    }
  }

  private func syncData() async {
    guard let teamInfo = currentTeamId else { return }
    do {
      try await teamGameInfoSyncUseCase.syncIfNeeded(TeamID(teamInfo))
      try await teamPlayersSyncUseCase.syncIfNeeded(TeamID(teamInfo))
      try await lineupSyncUseCase.syncIfNeeded(TeamID(teamInfo))
    } catch {
      print("Sync failed: \(error)")
    }
  }
}
