//
//  TeamMemberSongVO.swift
//  CheerLot
//
//  Created by 이승진 on 3/9/26.
//

import Foundation

struct TeamMemberSongVO: Identifiable {
  let playerId: PlayerID
  let playerName: String
  let backNumber: Int
  let songOrderLabel: String
  let cheerSong: CheerSongInfo

  var id: String { cheerSong.id }
}
