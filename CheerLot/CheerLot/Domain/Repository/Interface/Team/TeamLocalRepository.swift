//
//  TeamLocalRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

protocol TeamLocalRepository {
    /// SwiftData Team의 CRUD 메서드. TeamState Entity를 활용 및 반환한다.
    func fetchTeam(_ teamId: TeamID) async throws -> TeamState?
    func updateTeam(_ team: TeamState) async throws
    func teamExists(_ teamId: TeamID) async throws -> Bool
}
