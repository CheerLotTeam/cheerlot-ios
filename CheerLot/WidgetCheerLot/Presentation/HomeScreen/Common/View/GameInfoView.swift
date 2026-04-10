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
  let asset: WidgetTeamAssetVO

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                asset.primaryColor
                
                asset.widgetBackgroundGradient.opacity(0.2)
                    .overlay {
                        Image(.teamCardBG)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.3)
                            .blendMode(.softLight)
                            .clipped()
                    }
                
                contentsView
            }
            
            ReloadButton(color: asset.primaryPalette.color200)
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

      Text(title)
        .font(isSmallSize ? .SB5 : .SB3)
        .foregroundStyle(.grayWhite)
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
    }
}

#Preview {
  GameInfoView(
    isSmallSize: true, title: "시즌 종료", dateString: "00월 00일", capsuleTitle: "최근 라인업", asset: WidgetTeamAssetVO(TeamID(TeamDataSource.TeamCode.samsung.rawValue)))
}
