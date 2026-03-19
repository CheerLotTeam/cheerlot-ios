//
//  WatchSyncRepositoryImpl.swift
//  CheerLot
//
//  Created by 이현주 on 3/19/26.
//

import Foundation
import WatchConnectivity

final class WatchSyncRepositoryImpl: NSObject, WatchSyncRepository {

  private let session = WCSession.default

  override init() {
    super.init()
    guard WCSession.isSupported() else { return }
    session.delegate = self
    session.activate()
  }

  func sendTeamSelection(_ teamId: TeamID) {
    updateContext([WatchContextKey.selectedTeamId: teamId.value])
  }

  func sendLineup(_ players: [PlayerInfo]) {
    guard let data = try? JSONEncoder().encode(players.map { PlayerSyncDTO(from: $0) }) else { return }
    updateContext([WatchContextKey.lineup: data])
  }

  // MARK: - Private

  /// 기존 context에 병합하여 업데이트 (덮어쓰기 방지)
  private func updateContext(_ partial: [String: Any]) {
    guard session.activationState == .activated,
          session.isPaired,
          session.isWatchAppInstalled else { return }

    var merged = session.applicationContext
    merged.merge(partial) { _, new in new }

    do {
      try session.updateApplicationContext(merged)
    } catch {
      print("[WatchSync] updateApplicationContext 실패: \(error.localizedDescription)")
    }
  }
}

// MARK: - WCSessionDelegate

extension WatchSyncRepositoryImpl: WCSessionDelegate {

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    if let error {
      print("[WatchSync] 세션 활성화 실패: \(error.localizedDescription)")
    }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {
    session.activate()
  }
}
