//
//  WatchConnectivityRepositoryImpl.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityRepositoryImpl: NSObject, WatchConnectivityRepository {

  private let watchTeamRepository: WatchTeamRepository
  private let memberRepository: WatchMemberRepository

  init(
    watchTeamRepository: WatchTeamRepository,
    memberRepository: WatchMemberRepository
  ) {
    self.watchTeamRepository = watchTeamRepository
    self.memberRepository = memberRepository
  }

  deinit {
    WCSession.default.delegate = nil
  }

  func activate() {
    guard WCSession.isSupported() else { return }
    WCSession.default.delegate = self
    WCSession.default.activate()
  }

  // MARK: - Private

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
    memberRepository.saveLineupMembers(members, teamId: teamId)
    NotificationCenter.default.post(name: .watchDataReceived, object: nil)
  }

  private func applyContext(_ context: [String: Any]) {
    applyReceivedTeam(from: context)
    applyReceivedLineup(from: context)
  }
}

// MARK: - WCSessionDelegate

extension WatchConnectivityRepositoryImpl: WCSessionDelegate {

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    if let error {
      print("[WatchConnectivity] 세션 활성화 실패: \(error.localizedDescription)")
      return
    }
    applyContext(session.applicationContext)
  }

  func session(
    _ session: WCSession,
    didReceiveApplicationContext applicationContext: [String: Any]
  ) {
    applyContext(applicationContext)
  }
}
