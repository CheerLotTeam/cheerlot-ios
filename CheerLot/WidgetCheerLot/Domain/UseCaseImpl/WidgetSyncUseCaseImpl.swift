//
//  WidgetSyncUseCaseImpl.swift
//  WidgetCheerLot
//
//  Created by 이현주 on 4/6/26.
//

import Foundation

final class WidgetSyncUseCaseImpl: WidgetSyncUseCase {
  private let teamLocalRepository: TeamLocalRepository
  private let teamRemoteRepository: TeamRemoteRepository
  private let gameScheduleRepository: GameScheduleRepository
  private let userSettingsRepository: UserSettingsRepository

  init(
    teamLocalRepository: TeamLocalRepository,
    teamRemoteRepository: TeamRemoteRepository,
    gameScheduleRepository: GameScheduleRepository,
    userSettingsRepository: UserSettingsRepository
  ) {
    self.teamLocalRepository = teamLocalRepository
    self.teamRemoteRepository = teamRemoteRepository
    self.gameScheduleRepository = gameScheduleRepository
    self.userSettingsRepository = userSettingsRepository
  }

  // MARK: - WidgetSyncUseCase

  func syncAndFetch(for teamId: TeamID) async throws -> WidgetGamesInfo {
    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    // 1. 경기 정보 항상 fetch
    try await syncGameInfo(teamId, localTeam: localTeam)

    // 2. 오늘 날짜 기준으로 캐시가 없거나 오래됐을 때만 경기 일정 fetch
    let schedule: TeamGameScheduleInfo
    let cached = gameScheduleRepository.fetchGameSchedule(for: teamId)
    if let cached, cached.recentGames.first?.date == Date.now.yyyyMMddFormatted {
      schedule = cached
    } else {
      schedule = try await teamRemoteRepository.fetchGamesSchedule(teamId)
      gameScheduleRepository.saveGameSchedule(schedule, for: teamId)
    }

    // 3. 동기화 후 최신 팀 상태 조회
    guard let updatedTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    let resolvedStatus = resolvedGameStatus(updatedTeam.gameInfo.status, hasGame: schedule.recentGames.first?.hasGame)
    return WidgetGamesInfo(
      schedule: schedule,
      gameStatus: resolvedStatus
    )
  }

  func fetchLocal(for teamId: TeamID) async -> WidgetGamesInfo? {
    guard
      let schedule = gameScheduleRepository.fetchGameSchedule(for: teamId),
      let localTeam = try? await teamLocalRepository.fetchTeam(teamId)
    else { return nil }

    let resolvedStatus = resolvedGameStatus(localTeam.gameInfo.status, hasGame: schedule.recentGames.first?.hasGame)
    return WidgetGamesInfo(
      schedule: schedule,
      gameStatus: resolvedStatus
    )
  }
}

// MARK: - Private

extension WidgetSyncUseCaseImpl {
  private func resolvedGameStatus(_ status: GameStatus, hasGame: Bool?) -> GameStatus {
    guard hasGame == false else { return status }
    switch status {
    case .playingToday, .lineupPending: return .offDay
    case .offDay, .seasonEnded: return status
    }
  }

  private func syncGameInfo(_ teamId: TeamID, localTeam: TeamState) async throws {
    let gameInfo = try await teamRemoteRepository.fetchTodayGameInfo(teamId)

    userSettingsRepository.setLineupUpdatedToday(gameInfo.lineupUpdatedToday, for: teamId)

    let updatedTeam = TeamState(
      teamId: teamId,
      gameInfo: gameInfo,
      versionInfo: localTeam.versionInfo
    )
    try await teamLocalRepository.updateTeam(updatedTeam)
  }
}
