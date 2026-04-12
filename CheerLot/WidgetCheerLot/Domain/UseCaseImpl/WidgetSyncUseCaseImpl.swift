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
  private let playerLocalRepository: PlayerLocalRepository
  private let playerRemoteRepository: PlayerRemoteRepository
  private let gameScheduleRepository: GameScheduleRepository
  private let userSettingsRepository: UserSettingsRepository

  init(
    teamLocalRepository: TeamLocalRepository,
    teamRemoteRepository: TeamRemoteRepository,
    playerLocalRepository: PlayerLocalRepository,
    playerRemoteRepository: PlayerRemoteRepository,
    gameScheduleRepository: GameScheduleRepository,
    userSettingsRepository: UserSettingsRepository
  ) {
    self.teamLocalRepository = teamLocalRepository
    self.teamRemoteRepository = teamRemoteRepository
    self.playerLocalRepository = playerLocalRepository
    self.playerRemoteRepository = playerRemoteRepository
    self.gameScheduleRepository = gameScheduleRepository
    self.userSettingsRepository = userSettingsRepository
  }

  // MARK: - WidgetSyncUseCase

  func syncAndFetch(for teamId: TeamID) async throws -> WidgetGamesInfo {
    // 1. 버전 확인
    let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)

    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    // 2. 버전이 다르면 경기 정보 + 라인업 모두 동기화
    if localTeam.versionInfo.lineupVersion != serverVersions.lineupVersion {
      try await syncGameInfo(teamId, localTeam: localTeam)
      try await syncLineup(teamId, newVersion: serverVersions.lineupVersion)
    }

    // 3. 경기 일정 조회 → UserDefaults 저장
    let schedule = try await teamRemoteRepository.fetchGamesSchedule(teamId)
    gameScheduleRepository.saveGameSchedule(schedule, for: teamId)

    // 4. 동기화 후 최신 팀 상태 조회
    guard let updatedTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    return WidgetGamesInfo(
      schedule: schedule,
      gameStatus: updatedTeam.gameInfo.status
    )
  }

  func fetchLocal(for teamId: TeamID) async -> WidgetGamesInfo? {
    guard
      let schedule = gameScheduleRepository.fetchGameSchedule(for: teamId),
      let localTeam = try? await teamLocalRepository.fetchTeam(teamId)
    else { return nil }

    return WidgetGamesInfo(
      schedule: schedule,
      gameStatus: localTeam.gameInfo.status
    )
  }
}

// MARK: - Private

extension WidgetSyncUseCaseImpl {
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

  private func syncLineup(_ teamId: TeamID, newVersion: Int) async throws {
    let serverLineup = try await playerRemoteRepository.fetchLineup(teamId)
    let localPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)

    try await playerLocalRepository.performTransaction {
      for localPlayer in localPlayers where localPlayer.battingOrder != nil {
        let updated = PlayerInfo(
          id: localPlayer.id,
          teamId: localPlayer.teamId,
          name: localPlayer.name,
          backNumber: localPlayer.backNumber,
          position: localPlayer.position,
          batThrow: localPlayer.batThrow,
          battingOrder: nil,
          cheerSongs: localPlayer.cheerSongs
        )
        try await playerLocalRepository.updatePlayer(updated)
      }

      for lineupPlayer in serverLineup {
        if let localPlayer = try await playerLocalRepository.fetchPlayer(lineupPlayer.id) {
          let updated = PlayerInfo(
            id: localPlayer.id,
            teamId: localPlayer.teamId,
            name: localPlayer.name,
            backNumber: localPlayer.backNumber,
            position: lineupPlayer.position,
            batThrow: lineupPlayer.batThrow,
            battingOrder: lineupPlayer.battingOrder,
            cheerSongs: localPlayer.cheerSongs
          )
          try await playerLocalRepository.updatePlayer(updated)
        } else {
          try await playerLocalRepository.createPlayer(lineupPlayer, teamId)
        }
      }
    }

    try await updateLineupVersion(teamId, newVersion)
  }

  private func updateLineupVersion(_ teamId: TeamID, _ version: Int) async throws {
    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    let updatedTeam = TeamState(
      teamId: teamId,
      gameInfo: localTeam.gameInfo,
      versionInfo: TeamVersionInfo(
        id: teamId,
        lineupVersion: version,
        playersVersion: localTeam.versionInfo.playersVersion
      )
    )
    try await teamLocalRepository.updateTeam(updatedTeam)
  }
}
