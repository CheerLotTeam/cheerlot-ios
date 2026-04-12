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
    .configurationDisplayName("오늘 경기")
    .description("오늘 열리는 경기를 확인해요")
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
