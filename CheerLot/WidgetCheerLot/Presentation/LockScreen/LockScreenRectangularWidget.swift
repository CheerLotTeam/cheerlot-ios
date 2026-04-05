//
//  LockScreenRectangularWidget.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 4/2/26.
//

import SwiftUI
import WidgetKit

// MARK: - Entry

struct LockScreenRectangularEntry: TimelineEntry {
  let date: Date
  let displayState: DisplayState

  enum DisplayState {
    case playingToday(myTeam: String, opponent: String)
    case offDay
    case seasonEnded
  }
}

// MARK: - Provider

struct LockScreenRectangularProvider: TimelineProvider {
  func placeholder(in context: Context) -> LockScreenRectangularEntry {
    LockScreenRectangularEntry(
      date: .now,
      displayState: .playingToday(myTeam: "삼성", opponent: "LG")
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (LockScreenRectangularEntry) -> Void) {
    completion(
      LockScreenRectangularEntry(
        date: .now,
        displayState: .playingToday(myTeam: "삼성", opponent: "LG")
      )
    )
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<LockScreenRectangularEntry>) -> Void
  ) {
    let entry = fetchEntry()
    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
    completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
  }

  private func fetchEntry() -> LockScreenRectangularEntry {
    guard
      let defaults = UserDefaults(suiteName: AppGroup.id),
      let teamIdValue = defaults.string(forKey: UserDefaultsKey.selectedTeamId)
    else {
      return LockScreenRectangularEntry(date: .now, displayState: .offDay)
    }

    let myTeam = LockScreenTeamAssetVO(base: WidgetTeamAssetVO(teamIdValue))
    let isSeasonEnded = defaults.bool(forKey: UserDefaultsKey.Widget.isSeasonEnded)
    let hasTodayGame = defaults.bool(forKey: UserDefaultsKey.Widget.hasTodayGame)
    let opponentTeamId = defaults.string(forKey: UserDefaultsKey.Widget.opponentTeamId)

    let displayState: LockScreenRectangularEntry.DisplayState
    if isSeasonEnded {
      displayState = .seasonEnded
    } else if hasTodayGame {
      let opponentShortName = opponentTeamId.map { LockScreenTeamAssetVO(base: WidgetTeamAssetVO($0)).shortName } ?? "상대팀"
      displayState = .playingToday(myTeam: myTeam.shortName, opponent: opponentShortName)
    } else {
      displayState = .offDay
    }

    return LockScreenRectangularEntry(date: .now, displayState: displayState)
  }
}

// MARK: - View

struct LockScreenRectangularWidgetView: View {
  let entry: LockScreenRectangularEntry

  private var statusText: String {
    switch entry.displayState {
    case .playingToday(let myTeam, let opponent): return "\(myTeam) vs \(opponent)"
    case .offDay: return "경기 없음"
    case .seasonEnded: return "시즌 종료"
    }
  }

  var body: some View {
    HStack(spacing: 6) {
      Capsule()
        .frame(width: 5, height: 42)
        .foregroundStyle(.white)

      VStack(alignment: .leading, spacing: 2) {
        Text(entry.date, format: .dateTime.month().day())
          .font(.system(size: 16, weight: .medium))
          .foregroundStyle(.white).opacity(0.4)
        Text(statusText)
          .font(.system(size: 18, weight: .semibold))
          .foregroundStyle(.white)
      }

      Spacer()
    }
  }
}

// MARK: - Widget

struct LockScreenRectangularWidget: Widget {
  let kind: String = "LockScreenRectangularWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: LockScreenRectangularProvider()) { entry in
      LockScreenRectangularWidgetView(entry: entry)
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName("경기 일정")
    .description("오늘의 경기 일정을 잠금화면에서 확인하세요.")
    .supportedFamilies([.accessoryRectangular])
  }
}

// MARK: - Preview

#Preview(as: .accessoryRectangular) {
  LockScreenRectangularWidget()
} timeline: {
  LockScreenRectangularEntry(date: .now, displayState: .playingToday(myTeam: "삼성", opponent: "LG"))
  LockScreenRectangularEntry(date: .now, displayState: .offDay)
  LockScreenRectangularEntry(date: .now, displayState: .seasonEnded)
}
