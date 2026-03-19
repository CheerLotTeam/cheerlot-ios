//
//  WatchMemberRepositoryImpl.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

final class WatchMemberRepositoryImpl: WatchMemberRepository {

  private let defaults = UserDefaults.standard

  func fetchLineupMembers(teamId: TeamID) -> [PlayerInfo] {
    guard let data = defaults.data(forKey: WatchUserDefaultsKey.lineupMembers),
          let dtos = try? JSONDecoder().decode([PlayerSyncDTO].self, from: data)
    else { return [] }

    return dtos
      .map { $0.toPlayerInfo() }
      .filter { $0.teamId == teamId }
  }

  func saveLineupMembers(_ members: [PlayerInfo], teamId: TeamID) {
    let dtos = members.map { PlayerSyncDTO(from: $0) }
    guard let data = try? JSONEncoder().encode(dtos) else {
      print("[WatchMember] 멤버 저장 인코딩 실패")
      return
    }
    defaults.set(data, forKey: WatchUserDefaultsKey.lineupMembers)
  }
}
