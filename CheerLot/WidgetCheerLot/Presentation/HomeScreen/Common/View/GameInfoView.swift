//
//  GameInfoView.swift
//  CheerLot
//
//  Created by 이현주 on 4/5/26.
//

import SwiftUI
import WidgetKit

struct GameInfoView: View {
  let isSmallSize: Bool
  let title: String
  let dateString: String
  let capsuleTitle: String
  let asset: WidgetTeamAssetVO
  @Environment(\.widgetRenderingMode) var renderingMode

  var body: some View {
    ZStack(alignment: .topTrailing) {
        if renderingMode != .accented {
            asset.primaryColor
            asset.widgetBackgroundGradient.opacity(0.2)
        }

      contentsView

      ReloadButton(color: asset.primaryPalette.color200)
        .widgetAccentable()
        .padding([.top, .trailing], 18)
    }
  }
}

extension GameInfoView {
  private var textView: some View {
    VStack(spacing: isSmallSize ? 0 : 2) {
      Text(dateString)
        .font(.M5)
        .foregroundStyle(asset.primaryPalette.color200)
        .widgetAccentable()

      Text(title)
        .font(isSmallSize ? .SB5 : .SB3)
        .foregroundStyle(.grayWhite)
        .widgetAccentable()
    }
  }

  private var contentsView: some View {
    VStack(spacing: 0) {
      Spacer()
      Spacer()
      textView
      Spacer()
      CapsuleBaseView(
        title: capsuleTitle,
        bgColor: asset.primaryPalette.color500
      )
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  GameInfoView(
    isSmallSize: true, title: "시즌 종료", dateString: "00월 00일", capsuleTitle: "최근 라인업",
    asset: WidgetTeamAssetVO(TeamID(TeamDataSource.TeamCode.samsung.rawValue)))
}
