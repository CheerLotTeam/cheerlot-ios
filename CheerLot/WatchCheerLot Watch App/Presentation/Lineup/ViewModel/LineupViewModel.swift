//
//  LineupViewModel.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class LineupViewModel {

  // MARK: - State
  var isOnboardingPresented = true
  var lineupMembers: [LineupMemberVO] = []
  var asset: WatchTeamAssetVO?
  var teamName: String?

  private var currentTeamId: String?
  private var observationTask: Task<Void, Never>?

  // MARK: - Dependencies

  @ObservationIgnored
  @Injected(TeamFetchUseCase.self) private var teamFetchUseCase

  @ObservationIgnored
  @Injected(LineupFetchUseCase.self) private var lineupFetchUseCase

  // MARK: - Lifecycle

  deinit {
    observationTask?.cancel()
  }

  // MARK: - Action

  func onAppear() async {
    startObservingConnectivity()

    guard let teamInfo = teamFetchUseCase.getCurrentTeam() else { return }

    asset = WatchTeamAssetVO(teamInfo.id)
    teamName = teamInfo.shortName
    currentTeamId = teamInfo.id.value

    await loadLineupMembers()
  }

  // MARK: - Private

  private func loadLineupMembers() async {
    guard let teamId = currentTeamId else { return }

    do {
      let entities = try await lineupFetchUseCase.getLineupMembers(TeamID(teamId))
      lineupMembers = entities.map { LineupMemberVO(from: $0) }
    } catch {
      lineupMembers = []
    }
  }

  /// WCSession으로 데이터가 수신되면 최신 상태로 리로드
  private func startObservingConnectivity() {
    guard observationTask == nil else { return }

    observationTask = Task { @MainActor [weak self] in
      for await _ in NotificationCenter.default.notifications(named: .watchDataReceived) {
        await self?.onAppear()
      }
    }
  }
}
