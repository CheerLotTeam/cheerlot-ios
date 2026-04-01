//
//  CheerSongVO.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

struct CheerSongVO: Identifiable, Equatable {
  let id: String
  let playerId: String
  let title: String
  let lyrics: String
  let audioURL: String

  init(from entity: CheerSongInfo) {
    self.id = entity.id
    self.playerId = entity.playerId.value
    self.title = entity.title
    self.lyrics = entity.lyrics
    self.audioURL = entity.audioURL
  }

  func toEntity() -> CheerSongInfo {
    CheerSongInfo(
      id: id,
      playerId: PlayerID(playerId),
      title: title,
      lyrics: lyrics,
      audioURL: audioURL
    )
  }
}
