//
//  TeamGameInfoUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/25/26.
//

import Foundation

protocol TeamGameInfoUseCase {
  /// 오늘 경기 여부를 반환한다
  func isGameDay(_ teamId: TeamID) async -> Bool
}
