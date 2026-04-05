//
//  LockScreenTeamAssetVO.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 4/3/26.
//

import SwiftUI

struct LockScreenTeamAssetVO {
  let base: WidgetTeamAssetVO

  init(base: WidgetTeamAssetVO) {
    self.base = base
  }

  var shortName: String { base.shortName }
}
