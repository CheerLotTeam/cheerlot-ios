//
//  TeamMemberVO.swift
//  CheerLot
//
//  Created by 이승진 on 3/6/26.
//

import Foundation

struct TeamMemberVO: Identifiable {
  let playerId: PlayerID
  let name: String
  let backNumber: Int
  let hasSong: Bool

  var id: String { playerId.value }
}
