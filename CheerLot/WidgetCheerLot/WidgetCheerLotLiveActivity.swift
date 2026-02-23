//
//  WidgetCheerLotLiveActivity.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 2/10/26.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct WidgetCheerLotAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    // Dynamic stateful properties about your activity go here!
    var emoji: String
  }

  // Fixed non-changing properties about your activity go here!
  var name: String
}

struct WidgetCheerLotLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: WidgetCheerLotAttributes.self) { context in
      // Lock screen/banner UI goes here
      VStack {
        Text("Hello \(context.state.emoji)")
      }
      .activityBackgroundTint(Color.cyan)
      .activitySystemActionForegroundColor(Color.black)

    } dynamicIsland: { context in
      DynamicIsland {
        // Expanded UI goes here.  Compose the expanded UI through
        // various regions, like leading/trailing/center/bottom
        DynamicIslandExpandedRegion(.leading) {
          Text("Leading")
        }
        DynamicIslandExpandedRegion(.trailing) {
          Text("Trailing")
        }
        DynamicIslandExpandedRegion(.bottom) {
          Text("Bottom \(context.state.emoji)")
          // more content
        }
      } compactLeading: {
        Text("L")
      } compactTrailing: {
        Text("T \(context.state.emoji)")
      } minimal: {
        Text(context.state.emoji)
      }
      .widgetURL(URL(string: "http://www.apple.com"))
      .keylineTint(Color.red)
    }
  }
}

extension WidgetCheerLotAttributes {
  fileprivate static var preview: WidgetCheerLotAttributes {
    WidgetCheerLotAttributes(name: "World")
  }
}

extension WidgetCheerLotAttributes.ContentState {
  fileprivate static var smiley: WidgetCheerLotAttributes.ContentState {
    WidgetCheerLotAttributes.ContentState(emoji: "😀")
  }

  fileprivate static var starEyes: WidgetCheerLotAttributes.ContentState {
    WidgetCheerLotAttributes.ContentState(emoji: "🤩")
  }
}

#Preview("Notification", as: .content, using: WidgetCheerLotAttributes.preview) {
  WidgetCheerLotLiveActivity()
} contentStates: {
  WidgetCheerLotAttributes.ContentState.smiley
  WidgetCheerLotAttributes.ContentState.starEyes
}
