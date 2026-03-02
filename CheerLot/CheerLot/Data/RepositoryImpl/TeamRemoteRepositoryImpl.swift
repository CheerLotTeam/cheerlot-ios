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
    
    init(provider: MoyaProvider<TeamAPI> = MoyaProvider<TeamAPI>()) {
        self.provider = provider
    }
    
    func fetchGameInfo(_ teamId: TeamID) async throws -> TeamGameInfo {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getTeamGameInfo(teamCode: teamId.value)) { result in
                switch result {
                case .success(let response):
                    do {
                        let dto = try response.map(TeamGameDTO.self)
                        continuation.resume(returning: dto.toEntity())
                    } catch {
                        continuation.resume(throwing: NetworkError.decodingError(error))
                    }
                    
                case .failure(let error):
                    continuation.resume(
                        throwing: NetworkError.moyaError(error, api: .team(.matchInfo))
                    )
                }
            }
        }
    }
    
    func fetchVersions(_ teamId: TeamID) async throws -> TeamVersionInfo {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getTeamVersions(teamCode: teamId.value)) { result in
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
