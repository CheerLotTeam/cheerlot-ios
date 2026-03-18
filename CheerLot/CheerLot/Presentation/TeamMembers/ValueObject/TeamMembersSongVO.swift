//
//  TeamMembersSongVO.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

struct TeamMembersSongVO: Identifiable {
  let id: String
  let playerId: PlayerID
  let playerName: String
  let backNumber: Int
  let song: CheerSongInfo?
  
  var hasSong: Bool {
    song != nil
  }
  
  var titleText: String? {
    guard let song else { return nil }
    return song.title == "기본 응원가" ? nil : song.title
  }
}
