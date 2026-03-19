//
//  SearchResultVO.swift
//  CheerLot
//
//  Created by 이승진 on 3/19/26.
//

import Foundation

struct SearchResultVO: Identifiable, Equatable {
  let id: String
  let playerId: PlayerID
  let playerName: String
  let backNumber: Int
  let cheerSongs: [CheerSongInfo]
  let matchIndex: Int

  var hasSong: Bool {
    !cheerSongs.isEmpty
  }
}
