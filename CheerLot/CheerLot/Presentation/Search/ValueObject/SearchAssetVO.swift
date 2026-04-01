//
//  SearchAssetVO.swift
//  CheerLot
//
//  Created by 이승진 on 3/1/26.
//

import SwiftUI

// 검색 화면 전용 Asset VO입니다.
struct SearchAssetVO {
  // MARK: - Properties
  let base: TeamAssetVO

  // MARK: - Init

  init(base: TeamAssetVO) {
    self.base = base
  }

  // MARK: - Base Colors

  /// 팀 Primary 컬러
  var primaryColor: Color {
    base.primaryColor
  }

  /// 팀 Secondary 컬러
  var secondaryColor: Color {
    base.secondaryColor
  }
}
