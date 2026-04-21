//
//  WidgetConfiguration+.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/7/26.
//

import SwiftUI
import WidgetKit

extension WidgetConfiguration {
  func contentMarginsDisabledIfAvailable() -> some WidgetConfiguration {
    if #available(iOSApplicationExtension 17.0, *) {
      return self.contentMarginsDisabled()
    }
    return self
  }
}
