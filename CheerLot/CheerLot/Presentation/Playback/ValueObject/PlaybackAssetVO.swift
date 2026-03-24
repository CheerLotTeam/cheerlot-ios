//
//  PlaybackAssetVO.swift
//  CheerLot
//
//  Created by 이승진 on 3/24/26.
//

import SwiftUI

struct PlaybackAssetVO {
  let base: TeamAssetVO

  init(base: TeamAssetVO) {
    self.base = base
  }

  var primaryColor: Color { base.primaryColor }

  var dragHandleColor: Color {
    .grayWhite.opacity(0.5)
  }
  
  /// 가사 스크롤 하단 마스크 그라데이션
  var lyricsScrollMaskGradient: LinearGradient {
    LinearGradient(
      stops: [
        .init(color: .black, location: 0),
        .init(color: .black, location: 0.85),
        .init(color: .clear, location: 1),
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }

  var primaryTextColor: Color { .grayWhite }
  var secondaryTextColor: Color { .gray200 }
  var dimmedTextColor: Color { .grayWhite.opacity(0.5) }
}
