//
//  LineupPlaybackAssetVO.swift
//  CheerLot
//
//  Created by 이현주 on 3/9/26.
//

import SwiftUI

/// 라인업 카드재생 화면 전용 Asset VO입니다.
struct LineupPlaybackAssetVO {
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

  // MARK: - Play Card

  /// 카드 배경 그라데이션
  var cardBackgroundGradient: LinearGradient {
    LinearGradient(
        gradient: Gradient(stops: [
            .init(color: base.primaryPalette.color600, location: 0.0),
            .init(color: base.primaryPalette.color100, location: 0.66),
            .init(color: base.primaryPalette.color300, location: 1.0)
        ]),
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  /// 뷰 배경 그라데이션
  var playbackBackgroundGradient: LinearGradient {
    LinearGradient(
      colors: [
        base.primaryPalette.color200.opacity(0),
        base.primaryPalette.color200
      ],
      startPoint: UnitPoint(x: 0.5, y: 0.45),
      endPoint: .bottom
    )
  }
    
    /// 가사 스크롤 하단 마스크 그라데이션
    var lyricsScrollMaskGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: .black, location: 0),
                .init(color: .black, location: 0.85),
                .init(color: .clear, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

  /// 카드 스트로크 컬러
  var cardStrokeColor: Color {
    base.primaryPalette.color200
  }
    
    /// 카드 내부 내용 컬러
    var cardContentsColor: Color {
      base.primaryPalette.color200
    }

  /// 타순 텍스트 컬러
  var battingOrderTextColor: Color {
    if base.primaryColor == base.secondaryColor {
      return .grayWhite
    } else {
      return base.secondaryColor
    }
  }
    
    /// 사이드 카드 바탕 컬러
    var sideCardFillColor: Color {
        base.primaryPalette.color100
    }
    
    /// 페이지 인디케이터 컬러
    var pageIndicatorColor: Color {
      base.primaryPalette.color300
    }
    
    /// 1~9 battingOrder에 따라 사용하는 카드 BG
    private let playCardImages: [Image] = [
        Image("playCard1"),
        Image("playCard2"),
        Image("playCard3"),
        Image("playCard4"),
        Image("playCard5"),
        Image("playCard6"),
        Image("playCard7"),
        Image("playCard8"),
        Image("playCard9")
    ]
    
    /// battingOrder에 따른 카드 BG 추출 함수
    func playCardImage(for battingOrder: Int) -> Image? {
        guard battingOrder > 0, battingOrder <= playCardImages.count else { return nil }
        return playCardImages[battingOrder - 1]
    }
}
