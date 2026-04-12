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
        .widgetURL(URL(string: "cheerlot://lineup?from=\(WidgetKind.homeGameScheduleMedium)"))
    }
    .configurationDisplayName("전체 일정")
    .description("다가오는 경기 일정을 한눈에 확인해요")
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
