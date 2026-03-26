//
//  AnalyticsService.swift
//  CheerLot
//
//  Created by 이현주 on 3/25/26.
//

import Foundation

// MARK: - User Property

enum AnalyticsUserProperty: String {
  case teamId = "team_id"
  case totalPlayCount = "total_play_count"
}

// MARK: - Protocol

protocol AnalyticsService {
  func track(_ event: any AnalyticsEvent)
  func setUserId(_ id: String)
  func setUserProperty(_ key: AnalyticsUserProperty, value: Any)
  func incrementUserProperty(_ key: AnalyticsUserProperty)
}
