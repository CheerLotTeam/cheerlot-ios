//
//  LineupMemberVO.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

struct LineupMemberVO: Identifiable, Equatable {
  let id: String
  let teamId: String
  let battingOrder: Int?
  let name: String
  let hasSong: Bool
  let cheerSongs: [CheerSongVO]

  init(from entity: PlayerInfo) {
    self.id = entity.id.value
    self.teamId = entity.teamId.value
    self.battingOrder = entity.battingOrder
    self.name = entity.name
    self.hasSong = !entity.cheerSongs.isEmpty
    self.cheerSongs = entity.cheerSongs.map { CheerSongVO(from: $0) }
  }

  static func == (lhs: LineupMemberVO, rhs: LineupMemberVO) -> Bool {
    lhs.id == rhs.id
  }
}
