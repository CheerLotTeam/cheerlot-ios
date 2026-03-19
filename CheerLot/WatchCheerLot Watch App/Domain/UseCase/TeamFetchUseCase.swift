//
//  TeamFetchUseCase.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

protocol TeamFetchUseCase {
  /// 현재 선택된 팀 조회
  func getCurrentTeam() -> TeamInfo?
}
