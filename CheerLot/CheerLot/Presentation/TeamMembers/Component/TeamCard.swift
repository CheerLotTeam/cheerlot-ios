//
//  TeamCard.swift
//  CheerLot
//
//  Created by 이승진 on 2/2/26.
//

import SwiftUI

/// 전체 선수 화면의 팀 카드입니다.
struct TeamCard: View {

  // MARK: - Properties

  let asset: TeamMembersAssetVO

  // MARK: - Body

  var body: some View {
    ZStack {
      /// 기본 컬러
      asset.primaryColor

      /// 그라데이션
      asset.cardBackgroundGradient
        .opacity(0.2)

      /// 점박스 이미지
      Image(.teamCardBG)
        .resizable()
        .scaledToFill()
        .opacity(0.5)

      /// 텍스트 모음
      textContents
    }
    .frame(height: 100)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(asset.cardSubtitleColor, lineWidth: 2)
    )
  }
}

extension TeamCard {
  /// 팀 카드 텍스트 모음
  private var textContents: some View {
    VStack(alignment: .center, spacing: 4) {
      Text(asset.base.team.englishFullName)
        .font(.T2)
        .foregroundStyle(.grayWhite)
        .shadow(
          color: asset.cardTextShadowColor,
          radius: 8,
          x: 0,
          y: 1
        )

      Text(asset.base.team.slogan)
        .font(.M5)
        .foregroundStyle(asset.cardSubtitleColor)
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 27)
  }
}

#Preview {
  TeamCard(
    asset: TeamMembersAssetVO(
      base: TeamAssetVO(
        team: TeamDataSource.toEntity(.samsung)
      )
    )
  )
}
