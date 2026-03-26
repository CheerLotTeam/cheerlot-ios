//
//  TeamCardButton.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 설정 화면의 팀 카드 버튼입니다.
struct TeamCardButton: View {

  // MARK: - Properties
  let action: () -> Void
  let asset: SettingAssetVO
  let team: TeamInfo

  // MARK: - Body
  var body: some View {
    Button {
      action()
    } label: {
      ZStack {
        // 기본 컬러
        asset.primaryColor

        // 그라데이션
        asset.cardBackgroundGradient
          .opacity(0.2)

        // 점박스 이미지
        Image(.teamCardBG)
          .resizable()
          .scaledToFill()
          .opacity(0.5)
          .blendMode(.softLight)

      }
      .frame(height: 100)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(asset.cardSubtitleColor, lineWidth: 2)
      )
      .overlay(
        Image(systemName: "ellipsis")
          .resizable()
          .scaledToFit()
          .foregroundStyle(asset.teamColor200)
          .frame(width: 16)
          .padding(.top, 16)
          .padding(.trailing, 14),
        alignment: .topTrailing
      )
      .overlay(textContents)

    }
    .buttonStyle(.plain)
  }
}

extension TeamCardButton {
  /// 팀 카드 텍스트 모음
  private var textContents: some View {
    VStack(alignment: .center, spacing: 4) {
      Text(team.englishFullName)
        .font(.T2)
        .foregroundStyle(.grayWhite)
        .shadow(
          color: asset.cardTextShadowColor,
          radius: 8,
          x: 0,
          y: 1
        )

      Text(team.slogan)
        .font(.M5)
        .foregroundStyle(asset.cardSubtitleColor)
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 27)
  }
}

#Preview {
  TeamCardButton(
    action: { print("팀 카드 버튼입니다.") },
    asset: SettingAssetVO(
      base: TeamAssetVO(
        TeamDataSource.toEntity(.samsung).id
      )
    ), team: TeamDataSource.toEntity(.samsung)
  )
}
