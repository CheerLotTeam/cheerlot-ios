//
//  WatchDataSyncUseCaseImpl.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/22/26.
//

import Foundation

final class WatchDataSyncUseCaseImpl: WatchDataSyncUseCase {

    private let watchConnectivityRepository: WatchConnectivityRepository
    private let watchTeamRepository: WatchTeamRepository
    private let watchMemberRepository: WatchMemberRepository

    init(
        watchConnectivityRepository: WatchConnectivityRepository,
        watchTeamRepository: WatchTeamRepository,
        watchMemberRepository: WatchMemberRepository
    ) {
        self.watchConnectivityRepository = watchConnectivityRepository
        self.watchTeamRepository = watchTeamRepository
        self.watchMemberRepository = watchMemberRepository
    }

    func start() {
        watchConnectivityRepository.onContextReceived = { [weak self] context in
            self?.applyContext(context)
        }
        watchConnectivityRepository.activate()
    }

    // MARK: - Private

    private func applyContext(_ context: [String: Any]) {
        applyReceivedTeam(from: context)
        applyReceivedLineup(from: context)
    }

    private func applyReceivedTeam(from context: [String: Any]) {
        guard let teamId = context[WatchContextKey.selectedTeamId] as? String else { return }
        watchTeamRepository.saveTeamId(teamId)
        NotificationCenter.default.post(name: .watchDataReceived, object: nil)
    }

    private func applyReceivedLineup(from context: [String: Any]) {
        guard let data = context[WatchContextKey.lineup] as? Data,
              let dtos = try? JSONDecoder().decode([PlayerSyncDTO].self, from: data),
              let teamId = dtos.first.map({ TeamID($0.teamId) })
        else { return }

        let members = dtos.map { $0.toPlayerInfo() }
        watchMemberRepository.saveLineupMembers(members)
        NotificationCenter.default.post(name: .watchDataReceived, object: nil)
    }
}
