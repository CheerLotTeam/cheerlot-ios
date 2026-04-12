//
//  HomePlaybackWidget.swift
//  WidgetCheerLotExtension
//
//  Created by 이승진 on 4/12/26.
//

import SwiftUI
import WidgetKit

// MARK: - Entry

struct HomePlaybackEntry: TimelineEntry {
  let date: Date
  let teamId: String
  let displayState: DisplayState

  enum DisplayState {
    /// 앱 백그라운드 X: 팀 전체 응원가 모드
    case team(teamName: String, totalSongCount: Int)
    /// 앱 백그라운드 O: 선수 응원가 재생 중
    case player(playerName: String, songTitle: String)
  }
}

// MARK: - Provider

struct HomePlaybackProvider: TimelineProvider {
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  func placeholder(in context: Context) -> HomePlaybackEntry {
    HomePlaybackEntry(
      date: .now,
      teamId: "SAMSUNG",
      displayState: .team(teamName: "삼성 라이온즈", totalSongCount: 30)
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (HomePlaybackEntry) -> Void) {
    completion(
      HomePlaybackEntry(
        date: .now,
        teamId: "SAMSUNG",
        displayState: .team(teamName: "삼성 라이온즈", totalSongCount: 30)
      )
    )
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<HomePlaybackEntry>) -> Void
  ) {
    let entry = fetchEntry()
    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
    completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
  }

  private func fetchEntry() -> HomePlaybackEntry {
    guard let teamInfo = teamSelectionUseCase.getCurrentTeam() else {
      return HomePlaybackEntry(
        date: .now,
        teamId: "SAMSUNG",
        displayState: .team(teamName: "삼성", totalSongCount: 0)
      )
    }

    let defaults = UserDefaults(suiteName: AppGroup.id)
    let playerName = defaults?.string(forKey: UserDefaultsKey.Widget.playerName)

    if let playerName {
      let songTitle = defaults?.string(forKey: UserDefaultsKey.Widget.songTitle) ?? ""
      return HomePlaybackEntry(
        date: .now,
        teamId: teamInfo.id.value,
        displayState: .player(playerName: playerName, songTitle: songTitle)
      )
    } else {
      let songCount = defaults?.integer(forKey: UserDefaultsKey.Widget.totalSongCount) ?? 0
      return HomePlaybackEntry(
        date: .now,
        teamId: teamInfo.id.value,
        displayState: .team(teamName: teamInfo.shortName, totalSongCount: songCount)
      )
    }
  }
}

// MARK: - Widget

struct HomePlaybackWidget: Widget {
  let kind: String = WidgetKind.homePlaybackSmall

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: HomePlaybackProvider()) { entry in
      HomePlaybackWidgetView(entry: entry)
        .containerBackground(Color.clear, for: .widget)
    }
    .configurationDisplayName("응원가 플레이어")
    .description("응원가를 홈화면에서 바로 재생해요.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabledIfAvailable()
  }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
  HomePlaybackWidget()
} timeline: {
  HomePlaybackEntry(
    date: .now, teamId: "SAMSUNG",
    displayState: .team(teamName: "삼성 라이온즈", totalSongCount: 30))
  HomePlaybackEntry(
    date: .now, teamId: "SAMSUNG",
    displayState: .player(playerName: "김선수", songTitle: "기본 응원가"))
}
