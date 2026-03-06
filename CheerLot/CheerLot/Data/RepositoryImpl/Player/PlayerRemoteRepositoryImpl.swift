//
//  PlayerRemoteRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation
import Moya

final class PlayerRemoteRepositoryImpl: PlayerRemoteRepository {
  private let provider: MoyaProvider<PlayerAPI>

  init() {
    self.provider = NetworkProvider.shared.createProvider()
  }

  func fetchLineup(_ teamId: TeamID) async throws -> [PlayerInfo] {
    let normalizedId = teamId.value.uppercased()
    guard let teamCode = TeamDataSource.TeamCode(rawValue: normalizedId) else {
      throw LocalStorageError.invalidData
    }
    let apiTeamCode = TeamDataSource.toAPICode(teamCode)

    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getLineup(teamCode: apiTeamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let dto = try response.map(LineupDTO.self)
            continuation.resume(returning: dto.toEntity())
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }

        case .failure(let error):
          continuation.resume(
            throwing: NetworkError.moyaError(error, api: .player(.lineup))
          )
        }
      }
    }
  }

  func fetchPlayer(_ playerId: PlayerID) async throws -> PlayerInfo {
    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getPlayer(playerCode: playerId.value)) { result in
        switch result {
        case .success(let response):
          do {
            let dto = try response.map(PlayerDTO.self)
            continuation.resume(returning: dto.toEntity())
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }

        case .failure(let error):
          continuation.resume(
            throwing: NetworkError.moyaError(error, api: .player(.playerDetail))
          )
        }
      }
    }
  }

  func fetchAllPlayers(_ teamId: TeamID) async throws -> [PlayerInfo] {
    let normalizedId = teamId.value.uppercased()
    guard let teamCode = TeamDataSource.TeamCode(rawValue: normalizedId) else {
      throw LocalStorageError.invalidData
    }
    let apiTeamCode = TeamDataSource.toAPICode(teamCode)

    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getAllPlayers(teamCode: apiTeamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let dto = try response.map(AllPlayersDTO.self)
            continuation.resume(returning: dto.toEntity())
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }

        case .failure(let error):
          continuation.resume(
            throwing: NetworkError.moyaError(error, api: .player(.allPlayers))
          )
        }
      }
    }
  }
}
