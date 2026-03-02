//
//  PlayerLocalRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

protocol PlayerLocalRepository {
    /// SwiftData Player의 CRUD 메서드. PlayerInfo Entity를 활용 및 반환한다.
    func fetchPlayer(_ playerId: PlayerID) throws -> PlayerInfo?
    func fetchAllPlayers(_ teamId: TeamID) throws -> [PlayerInfo]
    func createPlayer(_ entity: PlayerInfo, teamId: TeamID) throws
    func createAllPlayers(_ entities: [PlayerInfo], teamId: TeamID) throws
    func updatePlayer(_ entity: PlayerInfo) throws
    func deletePlayer(_ playerId: PlayerID) throws
    func deleteAllPlayers(_ teamId: TeamID) throws
}
