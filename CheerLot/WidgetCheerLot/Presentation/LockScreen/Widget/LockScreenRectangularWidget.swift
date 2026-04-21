//
//  LockScreenRectangularWidget.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 4/2/26.
//

import SwiftUI
import WidgetKit

// MARK: - View

struct LockScreenRectangularWidgetView: View {
  let entry: TeamGamesEntry

  private var statusText: String {
    switch entry.gameStatus {
    case .teamEmpty: return "팀 정보 없음"
    case .playingToday:
      let isHome = entry.gameSchedule.first?.isHome == true
      let opponent = entry.gameSchedule.first?.opponentShortName ?? ""
      return
        "\(isHome ? opponent : entry.teamShortName) vs \(isHome ? entry.teamShortName : opponent)"
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
  let kind: String = WidgetKind.lockGameInfoRectangular

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: TeamGamesProvider()) { entry in
      LockScreenRectangularWidgetView(entry: entry)
        .containerBackground(.clear, for: .widget)
        .widgetURL(URL(string: "cheerlot://lineup?from=\(WidgetKind.lockGameInfoRectangular)"))
    }
    .configurationDisplayName("오늘 경기")
    .description("오늘 경기 일정 확인")
    .supportedFamilies([.accessoryRectangular])
  }
}

// MARK: - Preview

#Preview(as: .accessoryRectangular) {
  LockScreenRectangularWidget()
} timeline: {
  TeamGamesEntry.preview
  TeamGamesEntry.fallback
}
