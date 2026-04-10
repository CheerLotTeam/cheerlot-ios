//
//  LockScreenCircularWidget.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import SwiftUI
import WidgetKit

// MARK: - Entry

struct StaticEntry: TimelineEntry {
    let date: Date = .now
}

// MARK: - Provider
struct StaticProvider: TimelineProvider {
    func placeholder(in context: Context) -> StaticEntry { StaticEntry() }
    func getSnapshot(in context: Context, completion: @escaping (StaticEntry) -> Void) {
        completion(StaticEntry())
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<StaticEntry>) -> Void) {
        // 업데이트 굳이 필요없으므로 never
        completion(Timeline(entries: [StaticEntry()], policy: .never))
    }
}

// MARK: - View

struct LockScreenCircularWidgetView: View {
  var body: some View {
      ZStack {
          AccessoryWidgetBackground()
          Image(.widgetIcon)
              .resizable()
              .scaledToFit()
              .padding(9)
              .symbolRenderingMode(.hierarchical)
      }
  }
}

// MARK: - Widget

struct LockScreenCircularWidget: Widget {
  let kind: String = "LockScreenCircularWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: StaticProvider()) { _ in
      LockScreenCircularWidgetView()
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName("경기 일정")
    .description("오늘의 경기 일정을 잠금화면에서 확인하세요.")
    .supportedFamilies([.accessoryCircular])
  }
}

// MARK: - Preview

#Preview(as: .accessoryCircular) {
  LockScreenRectangularWidget()
} timeline: {
  StaticEntry()
}
