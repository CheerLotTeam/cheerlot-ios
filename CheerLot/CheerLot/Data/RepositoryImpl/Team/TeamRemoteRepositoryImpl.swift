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

  func fetchTodayGameInfo(_ teamId: TeamID) async throws -> TeamGameInfo {
    let apiTeamCode = try convertTeamIdToAPICode(teamId)

    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getTeamTodayGameInfo(teamCode: apiTeamCode)) { result in
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
            throwing: NetworkError.moyaError(error, api: .team(.todayGameInfo))
          )
        }
      }
    }
  }

  func fetchVersions(_ teamId: TeamID) async throws -> TeamVersionInfo {
    let apiTeamCode = try convertTeamIdToAPICode(teamId)

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

  func fetchGamesSchedule(_ teamId: TeamID) async throws -> TeamGameScheduleInfo {
    let apiTeamCode = try convertTeamIdToAPICode(teamId)

    return try await withCheckedThrowingContinuation { continuation in
      provider.request(.getTeamGamesInfo(teamCode: apiTeamCode)) { result in
        switch result {
        case .success(let response):
          do {
            let dto = try response.map(TeamGameScheduleDTO.self)
            continuation.resume(returning: dto.toEntity())
          } catch {
            continuation.resume(throwing: NetworkError.decodingError(error))
          }
        case .failure(let error):
          continuation.resume(
            throwing: NetworkError.moyaError(error, api: .team(.gamesInfo))
          )
        }
      }
    }
  }
}

extension TeamRemoteRepositoryImpl {
  func convertTeamIdToAPICode(_ teamId: TeamID) throws -> String {
    let normalizedId = teamId.value.uppercased()

    guard let teamCode = TeamDataSource.TeamCode(rawValue: normalizedId) else {
      throw LocalStorageError.invalidData
    }

    return TeamDataSource.toAPICode(teamCode)
  }
}
