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
  case check(action: () -> Void)
  case profile(action: () -> Void)
  case largeTitle(String)
  case inlineTitle(String)
  case gameInfo(date: String, teams: String)
  case custom(AnyView)
}

struct ToolBarItemBuilder {
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
          .font(.system(size: 18, weight: .medium))
          .foregroundStyle(.gray800)
      }

    case .close(let action):
      Button(action: action) {
        Image(systemName: "xmark")
          .font(.system(size: 18, weight: .medium))
          .foregroundStyle(.gray800)
      }

    case .check(let action):
      Button(action: action) {
        Image(systemName: "checkmark")
          .font(.system(size: 18, weight: .medium))
          .foregroundStyle(.gray800)
      }

    case .profile(let action):
      Button(action: action) {
        if #available(iOS 26.0, *) {
          Image(systemName: "person.fill")
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.gray800)
        } else {
          Image(systemName: "person.crop.circle")
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.gray800)
        }
      }

    case .largeTitle(let text):
      Text(text)
        .font(.B1)
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
          .foregroundStyle(.gray800)

        Text(teams)
          .font(.SB8)
          .foregroundStyle(.grayBlack)
      }

    case .custom(let view):
      view
    }
  }
}
