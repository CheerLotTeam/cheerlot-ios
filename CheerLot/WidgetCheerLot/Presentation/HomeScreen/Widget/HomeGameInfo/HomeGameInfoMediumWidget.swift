//
//  HomeGameInfoMediumWidget.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import SwiftUI
import WidgetKit

struct HomeGameInfoMediumWidget: Widget {
  let kind: String = WidgetKind.homeGameInfoMedium

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: TeamGamesProvider()) { entry in
      HomeGameInfoMediumWidgetView(entry: entry)
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
  HomeGameInfoMediumWidget()
} timeline: {
  TeamGamesEntry.preview
  TeamGamesEntry.fallback
}
