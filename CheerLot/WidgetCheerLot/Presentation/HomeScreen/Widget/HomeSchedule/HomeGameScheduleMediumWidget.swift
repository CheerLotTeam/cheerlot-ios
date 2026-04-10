//
//  HomeGameScheduleMediumWidget.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import SwiftUI
import WidgetKit

struct HomeGameScheduleMediumWidget: Widget {
    let kind: String = WidgetKind.homeGameScheduleMedium

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: TeamGamesProvider()) { entry in
      HomeGameScheduleMediumWidgetView(entry: entry)
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName("경기 일정")
    .description("오늘의 경기 일정을 잠금화면에서 확인하세요.")
    .supportedFamilies([.systemMedium])
    .contentMarginsDisabledIfAvailable()
  }
}

// MARK: - Preview

#Preview(as: .systemMedium) {
  HomeGameScheduleMediumWidget()
} timeline: {
  TeamGamesEntry.preview
  TeamGamesEntry.fallback
}

