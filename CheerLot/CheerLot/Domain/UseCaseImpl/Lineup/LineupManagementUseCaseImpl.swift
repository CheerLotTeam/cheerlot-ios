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
  private let gameScheduleRepository: GameScheduleRepository
  private let userSettingsRepository: UserSettingsRepository
  private let watchSyncRepository: WatchSyncRepository

  init(
    teamLocalRepository: TeamLocalRepository,
    teamRemoteRepository: TeamRemoteRepository,
    playerLocalRepository: PlayerLocalRepository,
    playerRemoteRepository: PlayerRemoteRepository,
    gameScheduleRepository: GameScheduleRepository,
    userSettingsRepository: UserSettingsRepository,
    watchSyncRepository: WatchSyncRepository
  ) {
    self.teamLocalRepository = teamLocalRepository
    self.teamRemoteRepository = teamRemoteRepository
    self.playerLocalRepository = playerLocalRepository
    self.playerRemoteRepository = playerRemoteRepository
    self.gameScheduleRepository = gameScheduleRepository
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

    if needsPlayersSync {
      try await syncPlayers(teamId, newVersion: serverVersions.playersVersion)
    }

    if needsLineupSync {
      try await syncGameInfo(teamId)
      try await syncLineup(teamId, newVersion: serverVersions.lineupVersion)
    }

    try await syncScheduleIfNeeded(teamId)
  }

  private func forceSync(_ teamId: TeamID) async throws {
    let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)

    try await syncGameInfo(teamId)
    try await syncPlayers(teamId, newVersion: serverVersions.playersVersion)
    try await syncLineup(teamId, newVersion: serverVersions.lineupVersion)
    try await syncScheduleIfNeeded(teamId)
  }

  // MARK: - Private Methods - Individual Sync

  private func syncGameInfo(_ teamId: TeamID) async throws {
    let gameInfo = try await teamRemoteRepository.fetchTodayGameInfo(teamId)

    userSettingsRepository.setLineupUpdatedToday(gameInfo.lineupUpdatedToday, for: teamId)

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

  private func syncScheduleIfNeeded(_ teamId: TeamID) async throws {
    let cached = gameScheduleRepository.fetchGameSchedule(for: teamId)

    guard cached?.recentGames.first?.date != Date.now.yyyyMMddFormatted else { return }

    let schedule = try await teamRemoteRepository.fetchGamesSchedule(teamId)
    gameScheduleRepository.saveGameSchedule(schedule, for: teamId)
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
  }

  // MARK: - Private Methods - Data Fetch

  private func fetchLocalData(_ teamId: TeamID) async throws -> LineupData {
    guard let teamData = try await teamLocalRepository.fetchTeam(teamId) else {
      throw LocalStorageError.notFound
    }

    // 라인업 선수 리스트
    let allPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)
    let lineupPlayers =
      allPlayers
      .filter { $0.battingOrder != nil }
      .sorted { ($0.battingOrder ?? 0) < ($1.battingOrder ?? 0) }

    // 오늘 라인업 업데이트 여부
    let lineupUpdatedToday = userSettingsRepository.getLineupUpdatedToday(for: teamId)

    /// 최근 3경기 스케줄 중 첫번째 경기 (오늘)
    let firstRecentGame = gameScheduleRepository.fetchGameSchedule(for: teamId)?.recentGames.first

    // 라인업이 오늘 업데이트됐을 때 스케줄의 isHome을 저장 (추후 recentGameInfo용으로 활용)
    if lineupUpdatedToday {
      userSettingsRepository.setLineupIsHome(firstRecentGame?.isHome, for: teamId)
    }

    // lineupUpdatedToday=false일 때 teamData.gameInfo는 최근 완료 경기 정보 (최근 투수, 상대팀, 날짜)
    // showLineup=true 시 ViewModel에서 사용하도록 전달
    let recentGameInfo: TeamGameInfo? = lineupUpdatedToday ? nil : teamData.gameInfo
    let recentGameIsHome: Bool? =
      lineupUpdatedToday ? nil : userSettingsRepository.getLineupIsHome(for: teamId)

    // 기본 화면 표시용: lineupUpdatedToday=true면 teamData 직접 사용, false면 스케줄 API 첫번째 경기 사용
    let todaySchedule = lineupUpdatedToday ? nil : firstRecentGame
    let opponentTeamId: TeamID? =
      lineupUpdatedToday ? teamData.gameInfo.opponent : todaySchedule?.opponentTeamId
    let starterPitcherName: String? =
      lineupUpdatedToday ? teamData.gameInfo.starterPitcherName : todaySchedule?.starterPitcherName
    let isHome: Bool? = firstRecentGame?.isHome

    // Entity단의 경기 상태 매칭
    let finalStatus: GameStatus =
      (teamData.gameInfo.status == .playingToday && !lineupUpdatedToday)
      ? .lineupPending
      : teamData.gameInfo.status

    let resolvedGameInfo = TeamGameInfo(
      id: teamData.gameInfo.id,
      status: finalStatus,
      opponent: opponentTeamId,
      starterPitcherName: starterPitcherName,
      lastGameDate: teamData.gameInfo.lastGameDate,
      lineupUpdatedToday: lineupUpdatedToday
    )

    return LineupData(
      gameInfo: resolvedGameInfo,
      lineupPlayers: lineupPlayers,
      isHome: isHome,
      recentGameInfo: recentGameInfo,
      recentGameIsHome: recentGameIsHome
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
