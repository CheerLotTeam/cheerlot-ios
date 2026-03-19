//
//  LineupFetchUseCase.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

protocol LineupFetchUseCase {
  /// 라인업 선수 조회 (타순 정렬됨)
  func getLineupMembers(_ teamId: TeamID) async throws -> [PlayerInfo]
}
