//
//  LineupManagementUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/14/26.
//

import Foundation

final class LineupManagementUseCaseImpl: LineupManagementUseCase {
  private let teamLocalRepository: TeamLocalRepository
  private let teamRemoteRepository: TeamRemoteRepository
  private let playerLocalRepository: PlayerLocalRepository
  private let playerRemoteRepository: PlayerRemoteRepository
  private let userSettingsRepository: UserSettingsRepository
  private let watchSyncRepository: WatchSyncRepository

  init(
    teamLocalRepository: TeamLocalRepository,
    teamRemoteRepository: TeamRemoteRepository,
    playerLocalRepository: PlayerLocalRepository,
    playerRemoteRepository: PlayerRemoteRepository,
    userSettingsRepository: UserSettingsRepository,
    watchSyncRepository: WatchSyncRepository
  ) {
    self.teamLocalRepository = teamLocalRepository
    self.teamRemoteRepository = teamRemoteRepository
    self.playerLocalRepository = playerLocalRepository
    self.playerRemoteRepository = playerRemoteRepository
    self.userSettingsRepository = userSettingsRepository
    self.watchSyncRepository = watchSyncRepository
  }

  // MARK: - Public Methods

  func loadCurrentLineup(for teamId: TeamID) async throws -> LineupData {
    let data = try await fetchLocalData(teamId)
    return data
  }

  func loadLineupWithSync(for teamId: TeamID) async throws -> LineupData {
    try await syncIfNeeded(teamId)

    let data = try await fetchLocalData(teamId)
    watchSyncRepository.sendTeamSelection(teamId)
    watchSyncRepository.sendLineup(data.lineupPlayers)
    return data
  }

  func refreshLineup(for teamId: TeamID) async throws -> LineupData {
    // 강제 동기화
    try await forceSync(teamId)

    let data = try await fetchLocalData(teamId)
    watchSyncRepository.sendTeamSelection(teamId)
    watchSyncRepository.sendLineup(data.lineupPlayers)
    return data
  }

  // MARK: - Private Methods - Sync

  private func syncIfNeeded(_ teamId: TeamID) async throws {
    let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)

    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    let localVersions = localTeam.versionInfo

    let needsPlayersSync = localVersions.playersVersion != serverVersions.playersVersion
    let needsLineupSync = localVersions.lineupVersion != serverVersions.lineupVersion

    // 경기 정보는 매일 바뀌므로 항상 갱신
    try await syncGameInfo(teamId)

    if needsPlayersSync {
      try await syncPlayers(teamId, newVersion: serverVersions.playersVersion)
    }

    if needsLineupSync {
      try await syncLineup(teamId, newVersion: serverVersions.lineupVersion)
    }
  }

  private func forceSync(_ teamId: TeamID) async throws {
    let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)

    try await syncGameInfo(teamId)
    try await syncPlayers(teamId, newVersion: serverVersions.playersVersion)
    try await syncLineup(teamId, newVersion: serverVersions.lineupVersion)
  }

  // MARK: - Private Methods - Individual Sync

  private func syncGameInfo(_ teamId: TeamID) async throws {
    let gameInfo = try await teamRemoteRepository.fetchTodayGameInfo(teamId)

    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    let updatedTeam = TeamState(
      teamId: teamId,
      gameInfo: gameInfo,
      versionInfo: localTeam.versionInfo
    )

    try await teamLocalRepository.updateTeam(updatedTeam)
  }

  private func syncPlayers(_ teamId: TeamID, newVersion: Int) async throws {
    let allPlayers = try await playerRemoteRepository.fetchAllPlayers(teamId)

    try await playerLocalRepository.performTransaction {
      try await playerLocalRepository.deleteAllPlayers(teamId)
      try await playerLocalRepository.createAllPlayers(allPlayers, teamId)
    }

    try await updatePlayersVersion(teamId, newVersion)
  }

  private func syncLineup(_ teamId: TeamID, newVersion: Int) async throws {
    let serverLineup = try await playerRemoteRepository.fetchLineup(teamId)

    let localPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)

    try await playerLocalRepository.performTransaction {
      for localPlayer in localPlayers where localPlayer.battingOrder != nil {
        let updatedPlayer = PlayerInfo(
          id: localPlayer.id,
          teamId: localPlayer.teamId,
          name: localPlayer.name,
          backNumber: localPlayer.backNumber,
          position: localPlayer.position,
          batThrow: localPlayer.batThrow,
          battingOrder: nil,
          cheerSongs: localPlayer.cheerSongs
        )
        try await playerLocalRepository.updatePlayer(updatedPlayer)
      }

      for lineupPlayer in serverLineup {
        if let localPlayer = try await playerLocalRepository.fetchPlayer(lineupPlayer.id) {
          let updatedPlayer = PlayerInfo(
            id: localPlayer.id,
            teamId: localPlayer.teamId,
            name: localPlayer.name,
            backNumber: localPlayer.backNumber,
            position: lineupPlayer.position,
            batThrow: lineupPlayer.batThrow,
            battingOrder: lineupPlayer.battingOrder,
            cheerSongs: localPlayer.cheerSongs
          )
          try await playerLocalRepository.updatePlayer(updatedPlayer)
        } else {
          try await playerLocalRepository.createPlayer(lineupPlayer, teamId)
        }
      }
    }

    try await updateLineupVersion(teamId, newVersion)
    userSettingsRepository.resetShowRecentLineup()
  }

  // MARK: - Private Methods - Data Fetch

  private func fetchLocalData(_ teamId: TeamID) async throws -> LineupData {
    guard let teamData = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    let allPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)
    let lineupPlayers =
      allPlayers
      .filter { $0.battingOrder != nil }
      .sorted { ($0.battingOrder ?? 0) < ($1.battingOrder ?? 0) }

    return LineupData(
      gameInfo: teamData.gameInfo,
      lineupPlayers: lineupPlayers,
      opponentTeamId: teamData.gameInfo.opponent
    )
  }

  // MARK: - Private Methods - Version Update

  private func updatePlayersVersion(_ teamId: TeamID, _ version: Int) async throws {
    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    let updatedVersionInfo = TeamVersionInfo(
      id: teamId,
      lineupVersion: localTeam.versionInfo.lineupVersion,
      playersVersion: version
    )

    let updatedTeam = TeamState(
      teamId: teamId,
      gameInfo: localTeam.gameInfo,
      versionInfo: updatedVersionInfo
    )

    try await teamLocalRepository.updateTeam(updatedTeam)
  }

  private func updateLineupVersion(_ teamId: TeamID, _ version: Int) async throws {
    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    let updatedVersionInfo = TeamVersionInfo(
      id: teamId,
      lineupVersion: version,
      playersVersion: localTeam.versionInfo.playersVersion
    )

    let updatedTeam = TeamState(
      teamId: teamId,
      gameInfo: localTeam.gameInfo,
      versionInfo: updatedVersionInfo
    )

    try await teamLocalRepository.updateTeam(updatedTeam)
  }
}
