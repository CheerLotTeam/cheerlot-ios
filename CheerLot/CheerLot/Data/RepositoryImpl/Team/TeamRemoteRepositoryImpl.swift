//
//  TeamRemoteRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation
import Moya

final class TeamRemoteRepositoryImpl: TeamRemoteRepository {
  private let provider: MoyaProvider<TeamAPI>

  init() {
    self.provider = NetworkProvider.shared.createProvider()
  }

  func fetchGameInfo(_ teamId: TeamID) async throws -> TeamGameInfo {
    let normalizedId = teamId.value.uppercased()
    guard let teamCode = TeamDataSource.TeamCode(rawValue: normalizedId) else {
      throw LocalStorageError.invalidData
    }
    let apiTeamCode = TeamDataSource.toAPICode(teamCode)

    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getTeamGameInfo(teamCode: apiTeamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let dto = try response.map(TeamGameDTO.self)
            continuation.resume(returning: try dto.toEntity())
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }

        case .failure(let error):
          continuation.resume(
            throwing: NetworkError.moyaError(error, api: .team(.gameInfo))
          )
        }
      }
    }
  }

  func fetchVersions(_ teamId: TeamID) async throws -> TeamVersionInfo {
    let normalizedId = teamId.value.uppercased()
    guard let teamCode = TeamDataSource.TeamCode(rawValue: normalizedId) else {
      throw LocalStorageError.invalidData
    }
    let apiTeamCode = TeamDataSource.toAPICode(teamCode)

    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getTeamVersions(teamCode: apiTeamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let dto = try response.map(TeamVersionsDTO.self)
            continuation.resume(returning: dto.toEntity())
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }

        case .failure(let error):
          continuation.resume(
            throwing: NetworkError.moyaError(error, api: .team(.versions))
          )
        }
      }
    }
  }
}
