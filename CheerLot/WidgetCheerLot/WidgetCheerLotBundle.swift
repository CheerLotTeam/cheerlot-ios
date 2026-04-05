//
//  WidgetCheerLotBundle.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 2/10/26.
//

import SwiftUI
import WidgetKit

@main
struct WidgetCheerLotBundle: WidgetBundle {
  var body: some Widget {
    WidgetCheerLot()
    WidgetCheerLotControl()
    WidgetCheerLotLiveActivity()
    LockScreenInlineWidget()
    LockScreenRectangularWidget()
    HomePlayerWidget()
  }
}
