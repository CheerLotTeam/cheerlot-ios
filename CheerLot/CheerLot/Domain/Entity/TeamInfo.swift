//
//  TeamInfo.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import Foundation

/// Team 정보
struct TeamInfo: Identifiable, Hashable, Equatable {
  let id: String
  let shortName: String
  let longName: String
  let englishFullName: String
  let slogan: String

  init(
    id: String,
    shortName: String,
    longName: String,
    englishFullName: String,
    slogan: String
  ) {
    self.id = id
    self.shortName = shortName
    self.longName = longName
    self.englishFullName = englishFullName
    self.slogan = slogan
  }
}
