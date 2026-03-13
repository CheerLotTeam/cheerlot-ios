//
//  TeamSelectVO.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

import Foundation

struct TeamSelectVO: Identifiable {
  let id: String
  let englishFullName: String
  let longName: String
}

extension TeamSelectVO {
  // Entity -> VO 변환
  init(from entity: TeamInfo) {
    self.id = entity.id.value
    self.englishFullName = entity.englishFullName.replacingOccurrences(of: " ", with: "\n")
    self.longName = entity.longName
  }
    
  static func == (lhs: TeamSelectVO, rhs: TeamSelectVO) -> Bool {
    lhs.id == rhs.id
  }
}
