//
//  PlayerSyncDTO.swift
//  CheerLot
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

struct PlayerSyncDTO: Codable {
  let id: String
  let teamId: String
  let name: String
  let backNumber: Int
  let position: String
  let batThrow: String
  let battingOrder: Int?
  let cheerSongs: [CheerSongSyncDTO]
}

struct CheerSongSyncDTO: Codable {
  let id: String
  let playerId: String
  let title: String
  let lyrics: String
  let audioURL: String
}

// MARK: - PlayerInfo ↔ DTO

extension PlayerSyncDTO {
  init(from entity: PlayerInfo) {
    self.id = entity.id.value
    self.teamId = entity.teamId.value
    self.name = entity.name
    self.backNumber = entity.backNumber
    self.position = entity.position
    self.batThrow = entity.batThrow
    self.battingOrder = entity.battingOrder
    self.cheerSongs = entity.cheerSongs.map { CheerSongSyncDTO(from: $0) }
  }

  func toPlayerInfo() -> PlayerInfo {
    PlayerInfo(
      id: PlayerID(id),
      teamId: TeamID(teamId),
      name: name,
      backNumber: backNumber,
      position: position,
      batThrow: batThrow,
      battingOrder: battingOrder,
      cheerSongs: cheerSongs.map { $0.toCheerSongInfo() }
    )
  }
}

extension CheerSongSyncDTO {
  init(from entity: CheerSongInfo) {
    self.id = entity.id
    self.playerId = entity.playerId.value
    self.title = entity.title
    self.lyrics = entity.lyrics
    self.audioURL = entity.audioURL
  }

  func toCheerSongInfo() -> CheerSongInfo {
    CheerSongInfo(
      id: id,
      playerId: PlayerID(playerId),
      title: title,
      lyrics: lyrics,
      audioURL: audioURL
    )
  }
}
