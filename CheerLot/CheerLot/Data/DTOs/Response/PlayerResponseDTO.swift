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
  let lyrics: String
  let audioUrl: String
}

extension LineupDTO {
  func toEntity() -> [PlayerInfo] {
    return players.map { starterDTO in
      PlayerInfo(
        id: PlayerID(starterDTO.playerCode),
        teamId: TeamID(teamCode),
        name: starterDTO.name,
        backNumber: starterDTO.backNumber,
        position: starterDTO.position ?? "교체선수",
        batThrow: starterDTO.batThrow ?? "",
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
    return players.map { playerDTO in
      PlayerInfo(
        id: PlayerID(playerDTO.playerCode),
        teamId: TeamID(playerDTO.teamCode),
        name: playerDTO.name,
        backNumber: playerDTO.backNumber,
        position: playerDTO.position ?? "교체선수",
        batThrow: playerDTO.batThrow ?? "",
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
    return PlayerInfo(
      id: PlayerID(self.playerCode),
      teamId: TeamID(self.teamCode),
      name: self.name,
      backNumber: self.backNumber,
      position: self.position ?? "교체선수",
      batThrow: self.batThrow ?? "",
      battingOrder: self.battingOrder,
      cheerSongs: self.cheerSongs.map {
        $0.toEntity(playerId: PlayerID(self.playerCode))
      }
    )
  }
}

extension CheerSongDTO {
  func toEntity(playerId: PlayerID) -> CheerSongInfo {
    return CheerSongInfo(
      id: "\(playerId.value)_\(title)",
      playerId: playerId,
      title: self.title,
      lyrics: self.lyrics,
      audioURL: self.audioUrl
    )
  }
}
