//
//  WatchConnectivityRepositoryImpl.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation
import WatchConnectivity

final class WatchConnectivityRepositoryImpl: NSObject, WatchConnectivityRepository {
    
    var onContextReceived: (([String: Any]) -> Void)?
    
    deinit {
        WCSession.default.delegate = nil
    }
    
    func activate() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
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
    onContextReceived?(session.receivedApplicationContext) // 콜백으로 전달
  }

  func session(
    _ session: WCSession,
    didReceiveApplicationContext applicationContext: [String: Any]
  ) {
    onContextReceived?(applicationContext) // 콜백으로 전달
  }
}
