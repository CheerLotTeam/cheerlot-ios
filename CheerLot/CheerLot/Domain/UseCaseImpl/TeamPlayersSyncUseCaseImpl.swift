//
//  TeamPlayersSyncUseCaseImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

final class TeamPlayersSyncUseCaseImpl: TeamPlayersSyncUseCase {
  private let teamLocalRepository: TeamLocalRepository
  private let teamRemoteRepository: TeamRemoteRepository
  private let playerLocalRepository: PlayerLocalRepository
  private let playerRemoteRepository: PlayerRemoteRepository

  init(
    teamLocalRepository: TeamLocalRepository,
    teamRemoteRepository: TeamRemoteRepository,
    playerLocalRepository: PlayerLocalRepository,
    playerRemoteRepository: PlayerRemoteRepository
  ) {
    self.teamLocalRepository = teamLocalRepository
    self.teamRemoteRepository = teamRemoteRepository
    self.playerLocalRepository = playerLocalRepository
    self.playerRemoteRepository = playerRemoteRepository
  }

  func getAllPlayers(_ teamId: TeamID) async throws -> [PlayerInfo] {
    try await playerLocalRepository.fetchAllPlayers(teamId)
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
      
    // 로컬 선수 존재 확인
    let localPlayers = try await playerLocalRepository.fetchAllPlayers(teamId)

    // 로컬 선수 데이터가 비어 있거나 버전이 다를경우 동기화
    if localPlayers.isEmpty || localTeam.versionInfo.playersVersion != serverVersions.playersVersion {
      try await performSync(teamId, serverVersions.playersVersion)
    }
  }

  func forceSync(_ teamId: TeamID) async throws {
    let serverVersions = try await teamRemoteRepository.fetchVersions(teamId)
    try await performSync(teamId, serverVersions.playersVersion)
  }

  // MARK: - Private Method

  private func performSync(_ teamId: TeamID, _ newVersion: Int) async throws {
    // 서버에서 전체 선수 가져오기
    let allPlayers = try await playerRemoteRepository.fetchAllPlayers(teamId)

    // 로컬 전체 삭제
    try await playerLocalRepository.deleteAllPlayers(teamId)

    // 새로 저장
    try await playerLocalRepository.createAllPlayers(allPlayers, teamId)

    // 팀 버전 업데이트
    try await updatePlayersVersion(teamId, newVersion)
  }

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
}
