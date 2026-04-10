//
//  LockScreenInlineWidget.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 4/2/26.
//

import SwiftUI
import WidgetKit

// MARK: - View

struct LockScreenInlineWidgetView: View {
  let entry: TeamGamesEntry

  private var statusText: String {
    switch entry.gameStatus {
    case .teamEmpty: return "팀 정보 없음"
    case .playingToday:
      let opponent = entry.gameSchedule.first?.opponentShortName ?? ""
      return "\(entry.teamShortName) VS \(opponent)"
    case .offDay: return "경기 없음"
    case .seasonEnded: return "시즌 종료"
    }
  }

  var body: some View {
    Label {
      Text(statusText)
    } icon: {
      switch entry.gameStatus {
      case .playingToday:
        Image(.widgetIcon)
          .symbolRenderingMode(.hierarchical)
      default:
        Image(systemName: "baseball.fill")
      }
    }
  }
}

// MARK: - Widget

struct LockScreenInlineWidget: Widget {
  let kind: String = WidgetKind.lockGameInfoInline

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: TeamGamesProvider()) { entry in
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
  TeamGamesEntry.preview
  TeamGamesEntry.fallback
}
