//
//  PlayerResponseDTO.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

struct LineupDTO: Decodable {
  let teamCode: String
  let role: String
  let players: [StarterDTO]
}

struct StarterDTO: Decodable {
  let battingOrder: Int
  let playerCode: String
  let name: String
  let position: String?
  let batThrow: String?
  let backNumber: Int
  let cheerSongs: [CheerSongDTO]
}

struct AllPlayersDTO: Decodable {
  let teamCode: String
  let players: [PlayerDTO]
}

struct PlayerDTO: Decodable {
  let playerCode: String
  let name: String
  let teamCode: String
  let position: String?
  let batThrow: String?
  let backNumber: Int
  let battingOrder: Int?
  let cheerSongs: [CheerSongDTO]
}

struct CheerSongDTO: Decodable {
  let title: String
  let lyrics: String?
  let audioUrl: String?
}

extension LineupDTO {
  func toEntity() -> [PlayerInfo] {
    players.map { starterDTO in
      PlayerInfo(
        id: PlayerID(starterDTO.playerCode),
        teamId: TeamID(teamCode),
        name: starterDTO.name,
        backNumber: starterDTO.backNumber,
        position: starterDTO.position,
        batThrow: starterDTO.batThrow,
        battingOrder: starterDTO.battingOrder,
        cheerSongs: starterDTO.cheerSongs.map {
          $0.toEntity(playerId: PlayerID(starterDTO.playerCode))
        }
      )
    }
  }
}

extension AllPlayersDTO {
  func toEntity() -> [PlayerInfo] {
    players.map { playerDTO in
      PlayerInfo(
        id: PlayerID(playerDTO.playerCode),
        teamId: TeamID(playerDTO.teamCode),
        name: playerDTO.name,
        backNumber: playerDTO.backNumber,
        position: playerDTO.position,
        batThrow: playerDTO.batThrow,
        battingOrder: playerDTO.battingOrder,
        cheerSongs: playerDTO.cheerSongs.map {
          $0.toEntity(playerId: PlayerID(playerDTO.playerCode))
        }
      )
    }
  }
}

extension PlayerDTO {
  func toEntity() -> PlayerInfo {
    PlayerInfo(
      id: PlayerID(playerCode),
      teamId: TeamID(teamCode),
      name: name,
      backNumber: backNumber,
      position: position,
      batThrow: batThrow,
      battingOrder: battingOrder,
      cheerSongs: cheerSongs.map {
        $0.toEntity(playerId: PlayerID(playerCode))
      }
    )
  }
}

extension CheerSongDTO {
  func toEntity(playerId: PlayerID) -> CheerSongInfo {
    CheerSongInfo(
      id: "\(playerId.value)_\(title)",
      playerId: playerId,
      title: title,
      lyrics: lyrics ?? "",
      audioURL: audioUrl ?? ""
    )
  }
}
