//
//  PlayerLocalRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation
import SwiftData

@ModelActor
actor PlayerLocalRepositoryImpl: PlayerLocalRepository {
  func fetchPlayer(_ playerId: PlayerID) throws -> PlayerInfo? {
    guard let player = try findPlayer(playerId: playerId) else {
      return nil
    }
    return player.toEntity()
  }

  func fetchAllPlayers(_ teamId: TeamID) throws -> [PlayerInfo] {
    let teamIdValue = teamId.value
    let descriptor = FetchDescriptor<Player>(
      predicate: #Predicate { $0.team?.teamId == teamIdValue }
    )
    do {
      let data = try modelContext.fetch(descriptor)
      return data.map { $0.toEntity() }
    } catch {
      throw LocalStorageError.fetchError
    }
  }
    
    func performTransaction<T>(_ operation: @Sendable () async throws -> T) async throws -> T {
        do {
            let result = try await operation()
            try modelContext.save()  // 커밋
            return result
        } catch {
            modelContext.rollback()  // 롤백
            throw error
        }
    }

  func createPlayer(_ entity: PlayerInfo, _ teamId: TeamID) throws {
    let team = try fetchTeam(teamId: teamId)
    let playerModel = createPlayerModel(from: entity, team: team)
    modelContext.insert(playerModel)

    for cheerSongEntity in entity.cheerSongs {
      let cheerSongModel = createCheerSongModel(
        from: cheerSongEntity,
        player: playerModel
      )
        modelContext.insert(cheerSongModel)
    }
  }

  func createAllPlayers(_ entities: [PlayerInfo], _ teamId: TeamID) throws {
    let team = try fetchTeam(teamId: teamId)

    for entity in entities {
      let model = createPlayerModel(from: entity, team: team)
        modelContext.insert(model)

      for cheerSongEntity in entity.cheerSongs {
        let cheerSongModel = createCheerSongModel(
          from: cheerSongEntity,
          player: model
        )
          modelContext.insert(cheerSongModel)
      }
    }
  }

  func updatePlayer(_ entity: PlayerInfo) throws {
    guard let model = try findPlayer(playerId: entity.id) else {
      throw LocalStorageError.notFound
    }

    model.name = entity.name
    model.backNumber = entity.backNumber
    model.position = entity.position
    model.batThrow = entity.batThrow
    model.battingOrder = entity.battingOrder

    // CheerSong은 기존 삭제 후, 새로 추가
    if let existingCheerSongs = model.cheerSongList {
      existingCheerSongs.forEach { modelContext.delete($0) }
    }

    for cheerSongEntity in entity.cheerSongs {
      let cheerSongModel = createCheerSongModel(
        from: cheerSongEntity,
        player: model
      )
      modelContext.insert(cheerSongModel)
    }
  }

  func deletePlayer(_ playerId: PlayerID) throws {
    guard let model = try findPlayer(playerId: playerId) else {
      throw LocalStorageError.notFound
    }
    modelContext.delete(model)
  }

  func deleteAllPlayers(_ teamId: TeamID) throws {
    let teamIdValue = teamId.value
    let descriptor = FetchDescriptor<Player>(
      predicate: #Predicate { $0.team?.teamId == teamIdValue }
    )
    let models = try modelContext.fetch(descriptor)
    models.forEach { modelContext.delete($0) }
  }
}

extension PlayerLocalRepositoryImpl {
  private func fetchTeam(teamId: TeamID) throws -> Team {
    let descriptor = FetchDescriptor<Team>(
      predicate: #Predicate { $0.teamId == teamId.value }
    )
    guard let team = try modelContext.fetch(descriptor).first else {
      throw LocalStorageError.notFound
    }
    return team
  }

  private func findPlayer(playerId: PlayerID) throws -> Player? {
    let predicate = #Predicate<Player> { $0.playerId == playerId.value }
    let descriptor = FetchDescriptor(predicate: predicate)

    do {
      return try modelContext.fetch(descriptor).first
    } catch {
      throw LocalStorageError.fetchError
    }
  }

  private func createPlayerModel(from entity: PlayerInfo, team: Team) -> Player {
    let player = Player(
      playerId: entity.id.value,
      name: entity.name,
      backNumber: entity.backNumber,
      position: entity.position,
      batThrow: entity.batThrow,
      battingOrder: entity.battingOrder
    )
    player.team = team
    return player
  }

  private func createCheerSongModel(from entity: CheerSongInfo, player: Player) -> CheerSong {
    let cheerSong = CheerSong(
      title: entity.title,
      lyrics: entity.lyrics,
      audioUrl: entity.audioURL,
      player: player
    )
    cheerSong.player = player
    return cheerSong
  }
}
