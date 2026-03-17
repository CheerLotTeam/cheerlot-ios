//
//  TeamLocalRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation
import SwiftData

@ModelActor
actor TeamLocalRepositoryImpl: TeamLocalRepository {
  func fetchTeam(_ teamId: TeamID) throws -> TeamState? {
    guard let team = try findTeam(teamId: teamId) else {
      return nil
    }
    return team.toEntity()
  }

  func updateTeam(_ team: TeamState) throws {
    guard let data = try findTeam(teamId: team.teamId) else {
      throw LocalStorageError.notFound
    }

    updateModelFromEntity(model: data, entity: team)
    try modelContext.save()
  }

  func teamExists(_ teamId: TeamID) throws -> Bool {
    return try findTeam(teamId: teamId) != nil
  }
}

extension TeamLocalRepositoryImpl {
  private func findTeam(teamId: TeamID) throws -> Team? {
    let predicate = #Predicate<Team> { $0.teamId == teamId.value }
    let descriptor = FetchDescriptor(predicate: predicate)

    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw LocalStorageError.fetchError
    }
  }

  private func updateModelFromEntity(model: Team, entity: TeamState) {
    switch entity.gameInfo.status {
    case .playingToday:
      model.hasTodayGame = true
      model.isSeasonEnded = false
    case .offDay:
      model.hasTodayGame = false
      model.isSeasonEnded = false
    case .seasonEnded:
      model.hasTodayGame = false
      model.isSeasonEnded = true
    }

    model.opponentTeamId = entity.gameInfo.opponent?.value
    model.starterPitcherName = entity.gameInfo.starterPitcherName
    model.lastGameDate = entity.gameInfo.lastGameDate
    model.lineupVersion = entity.versionInfo.lineupVersion
    model.playersVersion = entity.versionInfo.playersVersion
  }
}
