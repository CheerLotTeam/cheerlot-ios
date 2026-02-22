//
//  LineupAssetVO.swift
//  CheerLot
//
//  Created by 이현주 on 2/19/26.
//

import SwiftUI

/// 라인업 화면 전용 Asset VO입니다.
struct LineupAssetVO {
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

    // MARK: - Lineup Card

    /// 카드 배경 그라데이션
    var cardBackgroundGradient: LinearGradient {
      LinearGradient(
        colors: [
          base.primaryPalette.color600,
          base.primaryPalette.color200
        ],
        startPoint: .top,
        endPoint: .bottom
      )
    }
    
    /// 카드 스트로크 컬러
    var cardStrokeColor: Color {
        base.primaryPalette.color200
    }

    /// 카드 텍스트 그림자 컬러
    var cardTextShadowColor: Color {
      base.primaryPalette.color600
    }
    
    /// 선수 포지션 텍스트 컬러
    var positionTextColor: Color {
      base.primaryPalette.color200
    }
    
    /// 경기 정보 BG 컬러
    var matchInfoBgColor: Color {
        base.primaryPalette.color500
    }
    
    /// 재생 아이콘 disable 컬러
    var playDisableColor: Color {
        base.primaryPalette.color300
    }
    
    /// 라인업 카드 리스트 라인 컬러
    var listLineColor: Color {
        base.primaryPalette.color300
    }
}
