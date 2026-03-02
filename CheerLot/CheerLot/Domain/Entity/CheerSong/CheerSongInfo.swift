//
//  CheerSongInfo.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

/// 응원가 정보
struct CheerSongInfo: Identifiable, Hashable, Equatable {
  let id: String
  let playerId: PlayerID
  let title: String
  let lyrics: String
  let audioURL: String
}
