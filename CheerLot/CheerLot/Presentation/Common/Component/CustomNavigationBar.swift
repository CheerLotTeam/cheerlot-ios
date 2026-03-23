//
//  CustomNavigationBar.swift
//  CheerLot
//
//  Created by 이승진 on 6/2/25.
//

import SwiftUI

enum NavigationBarItem {
  case back(action: () -> Void)
  case close(action: () -> Void)
  case check(action: () -> Void, color: Color)
  case profile(action: () -> Void)
  case largeTitle(String)
  case inlineTitle(String)
  case gameInfo(date: String, teams: String)
  case custom(AnyView)
}

struct ToolBarItemBuilder {
    private static var systemImageFont: Font {
        if #available(iOS 26, *) {
            return .system(size: 14, weight: .semibold)
        } else {
            return .system(size: 18, weight: .medium)
        }
    }
    
  static func buildItem(for item: NavigationBarItem, placement: ToolbarItemPlacement)
    -> some ToolbarContent
  {
    ToolbarItem(placement: placement) {
      buildView(for: item)
    }
  }

  @ViewBuilder
  static func buildView(for item: NavigationBarItem) -> some View {
    switch item {
    case .back(let action):
      Button(action: action) {
        Image(systemName: "chevron.left")
          .font(systemImageFont)
      }
      .tint(.gray800)

    case .close(let action):
      Button(action: action) {
        Image(systemName: "xmark")
          .font(systemImageFont)
      }
      .tint(.gray800)

    case .check(let action, let color):
        Button(action: action) {
            Image(systemName: "checkmark")
                .font(systemImageFont)
        }
        .tint(color)
        .ifApply(color != .gray800 && UIDevice.isIOS26OrLater) {
            $0.buttonStyle(.borderedProminent)
        }

    case .profile(let action):
        Button(action: action) {
            Image(systemName: UIDevice.isIOS26OrLater ? "person.fill" : "person.crop.circle")
                .font(systemImageFont)
        }
        .tint(.gray800)

    case .largeTitle(let text):
        Text(text)
            .font(UIDevice.isIOS26OrLater ? .B1 : .B2)
            .foregroundStyle(.grayBlack)
            .fixedSize()

    case .inlineTitle(let text):
      Text(text)
        .font(.SB6)
        .foregroundStyle(.grayBlack)

    case .gameInfo(let date, let teams):
        VStack(alignment: .center, spacing: 0) {
            Text(date)
                .font(.M5)
                .foregroundStyle(UIDevice.isIOS26OrLater ? Color.gray800 : Color.gray600)
            Text(teams)
                .font(.SB8)
                .foregroundStyle(UIDevice.isIOS26OrLater ? Color.grayBlack : Color.gray800)
        }
        .fixedSize()
        
    case .custom(let view):
      view
    }
  }
}
