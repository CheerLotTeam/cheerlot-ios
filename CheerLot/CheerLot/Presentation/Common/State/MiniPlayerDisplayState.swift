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
  var isHidden: Bool = false

  func hide() {
    isHidden = true
  }

  func show() {
    isHidden = false
  }
}
