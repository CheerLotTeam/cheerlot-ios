//
//  LineupFetchUseCaseImpl.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

final class LineupFetchUseCaseImpl: LineupFetchUseCase {

  private let memberRepository: WatchMemberRepository

  init(memberRepository: WatchMemberRepository) {
    self.memberRepository = memberRepository
  }

  func getLineupMembers(_ teamId: TeamID) -> [PlayerInfo] {
    memberRepository.fetchLineupMembers()
      .filter { $0.battingOrder != nil }
      .sorted { ($0.battingOrder ?? 0) < ($1.battingOrder ?? 0) }
  }
}
