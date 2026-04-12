//
//  GameScheduleCell.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import SwiftUI

struct GameScheduleCell: View {
  let team: String
  let game: Game
  let asset: WidgetTeamAssetVO
  let isToday: Bool

  var body: some View {
    HStack {
      gameInfoTextView

      Spacer()

      Text(game.date.slashDateFormatted)
        .font(.M6)
        .foregroundStyle(asset.primaryPalette.color200)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 11)
    .background(
      RoundedRectangle(cornerRadius: 11)
        .fill(
          isToday ? .white.opacity(0.25) : .white.opacity(0.1)
        )
    )
  }
}

extension GameScheduleCell {
  private var gameInfoTextView: some View {
    Group {
      if let opponentId = game.opponentId {
        HStack(spacing: 6) {
          Text(game.isHome == true ? opponentId : team)
            .font(.T4)
          Text("vs")
            .font(.T5)
          Text(game.isHome == true ? team : opponentId)
            .font(.T4)
        }
        .foregroundStyle(.grayWhite)
      } else {
        Text("경기 없음")
          .font(.M5)
          .foregroundStyle(asset.primaryPalette.color200)
      }
    }
  }
}
