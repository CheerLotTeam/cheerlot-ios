//
//  TeamMembersAssetVO.swift
//  CheerLot
//
//  Created by 이승진 on 2/3/26.
//

import SwiftUI

/// 전체 선수 화면 전용 Asset VO입니다.
struct TeamMembersAssetVO {

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

  // MARK: - Team Card

  /// 카드 배경 그라데이션
  var cardBackgroundGradient: LinearGradient {
    LinearGradient(
      colors: [
        base.primaryPalette.color200,
        base.primaryPalette.color200,
        base.primaryPalette.color600,
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }

  /// 카드 서브 텍스트 컬러
  var cardSubtitleColor: Color {
    base.primaryPalette.color200
  }

  /// 카드 텍스트 그림자 컬러
  var cardTextShadowColor: Color {
    base.primaryPalette.color600
  }
}
