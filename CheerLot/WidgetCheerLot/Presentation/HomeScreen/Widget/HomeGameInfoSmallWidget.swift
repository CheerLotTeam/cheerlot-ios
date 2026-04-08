//
//  HomeGameInfoSmallWidget.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/7/26.
//

import SwiftUI
import WidgetKit

// MARK: - View

struct HomeGameInfoSmallWidgetView: View {
  let entry: TeamGamesEntry

  private var dateString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월 d일"
    return formatter.string(from: entry.date)
  }

  private var asset: WidgetTeamAssetVO {
    WidgetTeamAssetVO(TeamID(entry.teamId))
  }

  var body: some View {
    if entry.gameStatus == .teamEmpty {
      TeamEmptyView(isSmallSize: true)
    } else {
      let title: String = switch entry.gameStatus {
      case .playingToday: "\(entry.teamShortName) vs \(entry.gameSchedule.first?.opponentShortName ?? "")"
      case .offDay:       "경기 없음"
      case .seasonEnded:  "시즌 종료"
      case .teamEmpty:    ""
      }
      let capsuleTitle: String = switch entry.gameStatus {
      case .playingToday: "선발 라인업"
      case .offDay:       "이전 라인업"
      case .seasonEnded:  "최근 라인업"
      case .teamEmpty:    ""
      }
      let opponents = entry.gameSchedule.map { game in
        game.hasGame ? (game.opponentShortName ?? "?") : "휴"
      }.joined(separator: " · ")
      GameInfoView(isSmallSize: true, title: title, dateString: dateString, capsuleTitle: capsuleTitle, opponents: opponents, asset: asset)
    }
  }
}

// MARK: - Widget

struct HomeGameInfoSmallWidget: Widget {
  let kind: String = "HomeGameInfoSmallWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: TeamGamesProvider()) { entry in
      HomeGameInfoSmallWidgetView(entry: entry)
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName("경기 일정")
    .description("오늘의 경기 일정을 잠금화면에서 확인하세요.")
    .supportedFamilies([.systemSmall])
    .contentMarginsDisabledIfAvailable()
  }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
  HomeGameInfoSmallWidget()
} timeline: {
  TeamGamesEntry.preview
  TeamGamesEntry.fallback
}
