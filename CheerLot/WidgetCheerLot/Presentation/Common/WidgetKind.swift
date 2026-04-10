//
//  WidgetKind.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import Foundation

enum WidgetKind {
  static let lockGameInfoCircular = "LockScreenCircularWidget"
  static let lockGameInfoRectangular = "LockScreenRectangularWidget"
  static let lockGameInfoInline = "LockScreenInlineWidget"

  static let homeGameInfoSmall = "HomeGameInfoSmallWidget"
  static let homeGameInfoMedium = "HomeGameInfoMediumWidget"
  static let homeGameScheduleMedium = "HomeGameScheduleMediumWidget"

  static let homePlayerSmall = "HomePlayerWidget"

  static let gameInfoWidgets = [
    lockGameInfoCircular, lockGameInfoRectangular, lockGameInfoInline, homeGameInfoSmall,
    homeGameInfoMedium, homeGameScheduleMedium,
  ]
  static let musicWidgets = [homePlayerSmall]
}
