//
//  CheerSongVO.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

struct CheerSongVO: Identifiable, Equatable {
  let id: String
  let playerId: String
  let title: String
  let lyrics: String

  init(from entity: CheerSongInfo) {
    self.id = entity.id
    self.playerId = entity.playerId.value
    self.title = entity.title
    self.lyrics = entity.lyrics
  }
}
