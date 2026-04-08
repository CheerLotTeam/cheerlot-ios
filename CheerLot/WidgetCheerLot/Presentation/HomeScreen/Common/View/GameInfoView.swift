//
//  GameInfoView.swift
//  CheerLot
//
//  Created by 이현주 on 4/5/26.
//

import SwiftUI

struct GameInfoView: View {
  let isSmallSize: Bool
  let title: String
  let dateString: String
  let capsuleTitle: String
  let opponents: String
  let asset: WidgetTeamAssetVO

  var body: some View {
    ZStack {
      asset.primaryColor

      asset.widgetBackgroundGradient.opacity(0.2)

      //            Image(.teamCardBG)
      //                .resizable()
      //                .scaledToFill()
      //                .opacity(0.3)
      //                .blendMode(.softLight)

      VStack(spacing: 0) {
        Spacer()
        Spacer()
        TextView
        Spacer()
        CapsuleBaseView(
          title: capsuleTitle,
          bgColor: asset.primaryPalette.color500
        )
        Spacer()
      }
    }
  }
}

extension GameInfoView {
  private var TextView: some View {
    VStack(spacing: isSmallSize ? 0 : 2) {
      Text(dateString)
        .font(.M5)
        .foregroundStyle(asset.primaryPalette.color200)

      Text(title)
        .font(isSmallSize ? .SB5 : .SB3)
        .foregroundStyle(.grayWhite)

      Text(opponents)
        .font(.M5)
        .foregroundStyle(.grayWhite)
    }
  }
}

#Preview {
  GameInfoView(
    isSmallSize: true, title: "시즌 종료", dateString: "00월 00일", capsuleTitle: "최근 라인업", opponents: "",
    asset: WidgetTeamAssetVO(TeamID(TeamDataSource.TeamCode.samsung.rawValue)))
}
