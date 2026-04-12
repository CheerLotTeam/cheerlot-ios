//
//  HomeGameInfoSmallWidget.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/7/26.
//

import SwiftUI
import WidgetKit

struct HomeGameInfoSmallWidget: Widget {
  let kind: String = WidgetKind.homeGameInfoSmall

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: TeamGamesProvider()) { entry in
      HomeGameInfoSmallWidgetView(entry: entry)
        .containerBackground(.clear, for: .widget)
        .widgetURL(URL(string: "cheerlot://lineup?from=\(WidgetKind.homeGameInfoSmall)"))
    }
    .configurationDisplayName("오늘 경기")
    .description("오늘 열리는 경기를 확인해요")
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
