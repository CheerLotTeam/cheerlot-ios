//
//  AnalyticsEvent.swift
//  CheerLot
//
//  Created by 이현주 on 3/25/26.
//

import Foundation

// MARK: - Protocol

protocol AnalyticsEvent {
  var name: String { get }
  var parameters: [String: Any] { get }
}

// MARK: - Supporting Enums

enum AppEntryPoint: String {
  case app
  case widget
  case push  // 추후
}

enum PlaySource: String {
  case lineup
  case teamMembers
  case search
}

enum PlayViewType: String {
  case lineupPlayback = "lineup_playback"
  case playback
}

enum PlayTrigger: String {
  case userTap = "user_tap"
  case autoNext = "auto_next"
}

// MARK: - Events

struct AppOpenEvent: AnalyticsEvent {
  let entryPoint: AppEntryPoint
  let widgetId: String?
  let isGameDay: Bool

  var name: String { "app_open" }
  var parameters: [String: Any] {
    var params: [String: Any] = [
      "entry_point": entryPoint.rawValue,
      "is_game_day": isGameDay,
    ]
    if let widgetId { params["widget_id"] = widgetId }
    return params
  }
}

struct PlayViewPresentedEvent: AnalyticsEvent {
  let source: PlaySource
  let viewType: PlayViewType
  let isPlaying: Bool
  let isGameDay: Bool
  let playerId: String

  var name: String { "play_view_presented" }
  var parameters: [String: Any] {
    [
      "source": source.rawValue,
      "view_type": viewType.rawValue,
      "is_playing": isPlaying,
      "is_game_day": isGameDay,
      "player_id": playerId,
    ]
  }
}

struct PlayViewDismissedEvent: AnalyticsEvent {
  let source: PlaySource
  let viewType: PlayViewType
  let isPlaying: Bool
  let isGameDay: Bool
  let playerId: String

  var name: String { "play_view_dismissed" }
  var parameters: [String: Any] {
    [
      "source": source.rawValue,
      "view_type": viewType.rawValue,
      "is_playing": isPlaying,
      "is_game_day": isGameDay,
      "player_id": playerId,
    ]
  }
}

struct CheerPlayStartedEvent: AnalyticsEvent {
  let source: PlaySource
  let trigger: PlayTrigger
  let isGameDay: Bool
  let playerId: String

  var name: String { "cheer_play_started" }
  var parameters: [String: Any] {
    [
      "source": source.rawValue,
      "trigger": trigger.rawValue,
      "is_game_day": isGameDay,
      "player_id": playerId,
    ]
  }
}
