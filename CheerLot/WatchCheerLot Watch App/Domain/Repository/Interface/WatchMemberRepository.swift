//
//  WatchMemberRepository.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

/// Watch 로컬에 라인업 멤버 데이터를 저장/조회하는 Repository
protocol WatchMemberRepository {
  func fetchLineupMembers() -> [PlayerInfo]
  func saveLineupMembers(_ members: [PlayerInfo])
}
