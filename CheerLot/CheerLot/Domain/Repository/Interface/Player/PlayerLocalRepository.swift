//
//  PlayerLocalRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

protocol PlayerLocalRepository: Actor {
  /// SwiftData Player의 CRUD 메서드. PlayerInfo Entity를 활용 및 반환한다.
  func fetchPlayer(_ playerId: PlayerID) async throws -> PlayerInfo?
  func fetchAllPlayers(_ teamId: TeamID) async throws -> [PlayerInfo]
  func createPlayer(_ entity: PlayerInfo, _ teamId: TeamID) async throws
  func createAllPlayers(_ entities: [PlayerInfo], _ teamId: TeamID) async throws
  func updatePlayer(_ entity: PlayerInfo) async throws
  func deletePlayer(_ playerId: PlayerID) async throws
  func deleteAllPlayers(_ teamId: TeamID) async throws
}
