//
//  LineupPlayerVO.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

struct LineupPlayerVO: Identifiable, Equatable {
  let id: String
  let teamId: String
  let battingOrder: Int
  let name: String
  let backNumber: Int
  let position: String
  let batThrow: String
  let hasSong: Bool
  let cheerSongs: [CheerSongVO]

  init(from entity: PlayerInfo) {
    self.id = entity.id.value
    self.teamId = entity.teamId.value
    self.battingOrder = entity.battingOrder ?? 0
    self.name = entity.name
    self.backNumber = entity.backNumber
    self.position = entity.position ?? ""
    self.batThrow = entity.batThrow ?? ""
    self.hasSong = !entity.cheerSongs.isEmpty
    self.cheerSongs = entity.cheerSongs.map { CheerSongVO(from: $0) }
  }

  func toEntity() -> PlayerInfo {
    PlayerInfo(
      id: PlayerID(id),
      teamId: TeamID(teamId),
      name: name,
      backNumber: backNumber,
      position: position,
      batThrow: batThrow,
      battingOrder: battingOrder,
      cheerSongs: cheerSongs.map { $0.toEntity() }
    )
  }

  static func == (lhs: LineupPlayerVO, rhs: LineupPlayerVO) -> Bool {
    lhs.id == rhs.id
  }
}
