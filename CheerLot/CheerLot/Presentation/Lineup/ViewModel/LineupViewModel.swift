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

  private var showLineup: Bool = false
  private var recentGameInfoVO: LineupGameInfoVO?
  private var currentTeamId: String?
  private var hasTrackedAppOpen = false

  var gameStatus: GameStatus {
    gameInfo?.status ?? .offDay
  }

  var shouldShowLineup: Bool {
    gameStatus == .playingToday || showLineup
  }

  var displayGameInfoText: String {
    guard let gameInfo else { return "" }
    if showLineup, let recentVO = recentGameInfoVO {
      return recentVO.lastGameInfoText
    }
    return showLineup ? gameInfo.lastGameInfoText : gameInfo.todayGameInfoText
  }

  var displayStarterPitcherName: String? {
    if showLineup, let recentVO = recentGameInfoVO {
      return recentVO.starterPitcher
    }
    return gameInfo?.starterPitcher
  }

  var noGameMessage: String {
    switch gameStatus {
    case .lineupPending: return "오늘 라인업을 준비중이에요"
    case .offDay: return "오늘은 경기가 없는 날이에요"
    case .seasonEnded: return "다음 시즌 준비중이에요"
    case .playingToday: return ""
    }
  }

  var toggleShowLineupMessage: String {
    switch gameStatus {
    case .lineupPending, .seasonEnded: return "최근 경기 라인업 보기"
    case .offDay: return "이전 경기 라인업 보기"
    case .playingToday: return ""
    }
  }

  // MARK: - Dependencies

  @ObservationIgnored
  @Injected(AnalyticsService.self) private var analyticsService

  @ObservationIgnored
  @Injected(AppLaunchContext.self) private var launchContext

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

    asset = LineupAssetVO(base: TeamAssetVO(teamInfo.id))
    currentTeamId = teamInfo.id.value

    await loadData()

    if !hasTrackedAppOpen {
      hasTrackedAppOpen = true
      let widgetKind = launchContext.sourceWidgetKind
      launchContext.sourceWidgetKind = nil
      analyticsService.track(
        AppOpenEvent(
          entryPoint: widgetKind != nil ? .widget : .app,
          widgetId: widgetKind,
          isGameDay: [.playingToday, .lineupPending].contains(gameInfo?.status)
        )
      )
    }
  }

  func toggleShowLineup() {
    showLineup = true
  }

  func loadData() async {
    guard let teamId = currentTeamId else { return }

    guard !isLoading else { return }
    isLoading = true
    errorMessage = nil

    defer { isLoading = false }

    do {
      let data = try await lineupManagementUseCase.loadLineupWithSync(for: TeamID(teamId))

      convertToVO(data: data, teamId: teamId)
    } catch {
      if let error = error as? NetworkError, case .decodingError = error {
        errorMessage = "경기 정보를 준비하고 있어요\n잠시후 다시 확인해주세요"
      } else {
        errorMessage = "데이터를 불러올 수 없습니다: \(error.userMessage)"
      }
    }
  }

  func showNoSongToast() {
    toastMessage = "아직 개인 응원가가 없어요"
    showToast = true
  }

  func lineupPlaybackStartIndex(songId: String) -> Int {
    lineupPlayers
      .flatMap { $0.cheerSongs }
      .firstIndex { $0.id == songId } ?? 0
  }

  func handlePlayerTap(player: LineupPlayerVO) -> LineupTapAction {
    if player.cheerSongs.count >= 2 {
      return .showSongList(player: player)
    } else if let firstSong = player.cheerSongs.first {
      return .goToPlayback(startIndex: lineupPlaybackStartIndex(songId: firstSong.id))
    } else {
      showNoSongToast()
      return .none
    }
  }

  func handleSongSelect(song: CheerSongVO) -> LineupTapAction {
    .goToPlayback(startIndex: lineupPlaybackStartIndex(songId: song.id))
  }

  // MARK: - Private
  private func convertToVO(data: LineupData, teamId: String) {
    guard let teamInfo = teamInfoUseCase.getTeamInfo(TeamID(teamId)) else { return }

    // 상대팀 정보 조회
    let opponentTeamInfo = data.opponentTeamId.flatMap {
      teamInfoUseCase.getTeamInfo($0)
    }

    // GameInfo VO 변환
    gameInfo = LineupGameInfoVO(
      teamInfo: teamInfo,
      opponentTeamInfo: opponentTeamInfo,
      gameInfo: data.gameInfo,
      isHome: data.isHome
    )

    // 최근 완료 경기 VO (showLineup=true 시 사용)
    if let recentInfo = data.recentGameInfo {
      let recentOpponentInfo = recentInfo.opponent.flatMap { teamInfoUseCase.getTeamInfo($0) }
      recentGameInfoVO = LineupGameInfoVO(
        teamInfo: teamInfo,
        opponentTeamInfo: recentOpponentInfo,
        gameInfo: recentInfo
      )
    } else {
      recentGameInfoVO = nil
    }

    // Lineup Players VO 변환
    lineupPlayers = data.lineupPlayers.map { LineupPlayerVO(from: $0) }
  }
}

enum LineupTapAction {
  case showSongList(player: LineupPlayerVO)
  case goToPlayback(startIndex: Int)
  case none
}
