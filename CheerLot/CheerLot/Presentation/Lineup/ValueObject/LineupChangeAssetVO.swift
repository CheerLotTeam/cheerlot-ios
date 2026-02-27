//
//  LineupChangeAssetVO.swift
//  CheerLot
//
//  Created by 이현주 on 2/23/26.
//

import SwiftUI

/// 선수교체 화면 전용 Asset VO입니다.
struct LineupChangeAssetVO {
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

  // MARK: - Player Cell

  /// cell 쉐도우 컬러
  var cellShadowColor: Color {
    base.primaryColor.opacity(0.15)
  }

  /// select cell stroke 컬러
  var selectedCellStrokeColor: Color {
    base.primaryPalette.color200
  }

  /// select cell fill 컬러
  var selectedCellFillColor: Color {
    base.primaryPalette.color100
  }
}
