//
//  MiniPlayerDisplayState.swift
//  CheerLot
//
//  Created by 이승진 on 3/23/26.
//

import Observation

/// 미니플레이어 표시 여부를 관리하는 공용 UI 상태입니다.
@Observable
final class MiniPlayerDisplayState {
  private var hiddenCount: Int = 0

  var isHidden: Bool {
    hiddenCount > 0
  }

  func hide() {
    hiddenCount += 1
  }

  func show() {
    hiddenCount = max(0, hiddenCount - 1)
  }
}
