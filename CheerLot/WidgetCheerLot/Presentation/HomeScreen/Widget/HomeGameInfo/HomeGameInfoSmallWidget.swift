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
