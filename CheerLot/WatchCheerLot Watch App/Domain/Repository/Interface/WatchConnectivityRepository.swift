//
//  WatchConnectivityRepository.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

/// iPhone → Watch 데이터 수신 Repository
protocol WatchConnectivityRepository {
  /// WCSession 활성화 (앱 시작 시 1회 호출)
  func activate()
}

extension Notification.Name {
  /// WCSession으로 팀/라인업 데이터를 수신했을 때 발송
  static let watchDataReceived = Notification.Name("watchDataReceived")
}
