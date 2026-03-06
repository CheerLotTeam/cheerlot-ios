//
//  PlayerInfo.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

/// 선수 정보
struct PlayerInfo: Identifiable, Hashable, Equatable {
  let id: PlayerID
  let teamId: TeamID
  let name: String
  let backNumber: Int
  var position: String?
  var batThrow: String?
  var battingOrder: Int?
  var cheerSongs: [CheerSongInfo]

  init(
    id: PlayerID, teamId: TeamID, name: String, backNumber: Int, position: String? = nil,
    batThrow: String? = nil, battingOrder: Int? = nil, cheerSongs: [CheerSongInfo] = []
  ) {
    self.id = id
    self.teamId = teamId
    self.name = name
    self.backNumber = backNumber
    self.position = position
    self.batThrow = batThrow
    self.battingOrder = battingOrder
    self.cheerSongs = cheerSongs
  }
}

struct PlayerID: Hashable, Codable {
  let value: String

  init(_ value: String) {
    self.value = value
  }
}

extension PlayerID: ExpressibleByStringLiteral {
  init(stringLiteral value: String) {
    self.init(value)
  }
}
