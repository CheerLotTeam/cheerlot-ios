//
//  PlayerLocalRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation
import SwiftData

protocol PlayerLocalRepository: Actor {
  /// 트랜잭션으로 원자성 보장하는 메서드, 모두 성공시 커밋 / 실패시 롤백
  func performTransaction<T>(_ operation: @Sendable () async throws -> T) async throws -> T
  /// SwiftData Player의 CRUD 메서드. PlayerInfo Entity를 활용 및 반환한다. create/update/delete 메서드는 context을 주입받아 하나의 트랜잭션을 수행할 수 있도록 함.
  func fetchPlayer(_ playerId: PlayerID) async throws -> PlayerInfo?
  func fetchAllPlayers(_ teamId: TeamID) async throws -> [PlayerInfo]
  func createPlayer(_ entity: PlayerInfo, _ teamId: TeamID) async throws
  func createAllPlayers(_ entities: [PlayerInfo], _ teamId: TeamID) async throws
  func updatePlayer(_ entity: PlayerInfo) async throws
  func deletePlayer(_ playerId: PlayerID) async throws
  func deleteAllPlayers(_ teamId: TeamID) async throws
}
