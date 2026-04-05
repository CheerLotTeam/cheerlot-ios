//
//  LockScreenInlineWidget.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 4/2/26.
//

import SwiftUI
import WidgetKit

// MARK: - Entry

struct LockScreenInlineEntry: TimelineEntry {
  let date: Date
  let displayState: DisplayState

  enum DisplayState {
    case playingToday(myTeam: String, opponent: String)
    case offDay
    case seasonEnded
  }
}

// MARK: - Provider

struct LockScreenInlineProvider: TimelineProvider {
  func placeholder(in context: Context) -> LockScreenInlineEntry {
    LockScreenInlineEntry(date: .now, displayState: .playingToday(myTeam: "삼성", opponent: "한화"))
  }

  func getSnapshot(in context: Context, completion: @escaping (LockScreenInlineEntry) -> Void) {
    completion(
      LockScreenInlineEntry(date: .now, displayState: .playingToday(myTeam: "삼성", opponent: "한화")))
  }

  func getTimeline(
    in context: Context, completion: @escaping (Timeline<LockScreenInlineEntry>) -> Void
  ) {
    let entry = fetchEntry()
    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
    completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
  }

  private func fetchEntry() -> LockScreenInlineEntry {
    guard
      let defaults = UserDefaults(suiteName: AppGroup.id),
      let teamIdValue = defaults.string(forKey: UserDefaultsKey.selectedTeamId)
    else {
      return LockScreenInlineEntry(date: .now, displayState: .offDay)
    }

    let myTeam = LockScreenTeamAssetVO(base: WidgetTeamAssetVO(teamIdValue))
    let isSeasonEnded = defaults.bool(forKey: UserDefaultsKey.Widget.isSeasonEnded)
    let hasTodayGame = defaults.bool(forKey: UserDefaultsKey.Widget.hasTodayGame)
    let opponentTeamId = defaults.string(forKey: UserDefaultsKey.Widget.opponentTeamId)

    let displayState: LockScreenInlineEntry.DisplayState
    if isSeasonEnded {
      displayState = .seasonEnded
    } else if hasTodayGame {
      let opponentShortName =
        opponentTeamId.map { LockScreenTeamAssetVO(base: WidgetTeamAssetVO($0)).shortName } ?? "상대팀"
      displayState = .playingToday(myTeam: myTeam.shortName, opponent: opponentShortName)
    } else {
      displayState = .offDay
    }

    return LockScreenInlineEntry(date: .now, displayState: displayState)
  }
}

// MARK: - View

struct LockScreenInlineWidgetView: View {
  let entry: LockScreenInlineEntry

  private var statusText: String {
    switch entry.displayState {
    case .playingToday(let myTeam, let opponent): return "\(myTeam) VS \(opponent)"
    case .offDay: return "경기 없음"
    case .seasonEnded: return "시즌 종료"
    }
  }

  var body: some View {
    Label {
      Text(statusText)
    } icon: {
      switch entry.displayState {
      case .playingToday:
        Image("widgetIcon")
      default:
        Image(systemName: "baseball")
      }
    }
  }
}

// MARK: - Widget

struct LockScreenInlineWidget: Widget {
  let kind: String = "LockScreenInlineWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: LockScreenInlineProvider()) { entry in
      LockScreenInlineWidgetView(entry: entry)
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName("경기 일정")
    .description("오늘의 경기 일정을 잠금화면에서 확인하세요.")
    .supportedFamilies([.accessoryInline])
  }
}

// MARK: - Preview

#Preview(as: .accessoryInline) {
  LockScreenInlineWidget()
} timeline: {
  LockScreenInlineEntry(date: .now, displayState: .playingToday(myTeam: "삼성", opponent: "한화"))
  LockScreenInlineEntry(date: .now, displayState: .offDay)
  LockScreenInlineEntry(date: .now, displayState: .seasonEnded)
}
