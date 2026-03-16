//
//  LineupSyncUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

final class LineupSyncUseCaseImpl: LineupSyncUseCase {
  private let teamLocalRepository: TeamLocalRepository
  private let teamRemoteRepository: TeamRemoteRepository
  private let playerLocalRepository: PlayerLocalRepository
  private let playerRemoteRepository: PlayerRemoteRepository
  private let userSettingsRepository: UserSettingsRepository

  init(
    teamLocalRepository: TeamLocalRepository,
    teamRemoteRepository: TeamRemoteRepository,
    playerLocalRepository: PlayerLocalRepository,
    playerRemoteRepository: PlayerRemoteRepository,
    userSettingsRepository: UserSettingsRepository
  ) {
    self.teamLocalRepository = teamLocalRepository
    self.teamRemoteRepository = teamRemoteRepository
    self.playerLocalRepository = playerLocalRepository
    self.playerRemoteRepository = playerRemoteRepository
    self.userSettingsRepository = userSettingsRepository
  }

  func getCurrentLineup(_ teamId: TeamID) async throws -> [PlayerInfo] {
    let allPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)

    return
      allPlayers
      .filter { $0.battingOrder != nil }
      .sorted { ($0.battingOrder ?? 0) < ($1.battingOrder ?? 0) }
  }

  func syncIfNeeded(_ teamId: TeamID) async throws {
    // 서버 버전 확인
    let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)

    // 로컬 버전 확인
    guard let localTeam = try await teamLocalRepository.fetchTeam(teamId) else {
      // 로컬에 없으면 무조건 동기화
      try await forceSync(teamId)
      return
    }

    // 버전 비교
    if localTeam.versionInfo.lineupVersion != serverVersions.lineupVersion {
      userSettingsRepository.resetShowRecentLineup()
      try await performSync(teamId, serverVersions.lineupVersion)
    }
  }

  func forceSync(_ teamId: TeamID) async throws {
    let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)
    userSettingsRepository.resetShowRecentLineup()
    try await performSync(teamId, serverVersions.lineupVersion)
  }

  // MARK: - Private Method

  private func performSync(_ teamId: TeamID, _ newVersion: Int) async throws {
    // 서버 라인업 가져오기
    let serverLineup = try await playerRemoteRepository.fetchLineup(teamId)

    // 로컬 선수들 조회
    let localPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)

    // 기존 라인업 선수들의 타순 제거
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

    // 새 라인업 선수들에게 타순 부여
    for lineupPlayer in serverLineup {
      if let localPlayer = try await playerLocalRepository.fetchPlayer(lineupPlayer.id) {
        // 이미 있는 선수 → 타순만 업데이트
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
        // 없는 선수 → 새로 생성
        try await playerLocalRepository.createPlayer(lineupPlayer, teamId)
      }
    }

    // 팀 버전 업데이트
    try await updateLineupVersion(teamId, newVersion)
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
