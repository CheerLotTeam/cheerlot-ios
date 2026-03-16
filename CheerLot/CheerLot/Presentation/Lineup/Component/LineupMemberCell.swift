//
//  LineupMemberCell.swift
//  CheerLot
//
//  Created by 이현주 on 2/19/26.
//

import SwiftUI

/// 라인업 List Cell 입니다.
struct LineupMemberCell: View {
  let player: LineupPlayerVO
  let asset: LineupAssetVO

  var body: some View {
    HStack(spacing: 12) {
        if let battingOrder = player.battingOrder {
            Text("\(battingOrder)")
                .font(.M0)
                .foregroundStyle(asset.battingOrderTextColor)
        }

      textContents

      Spacer()

      Image(systemName: "play.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 14)
        .frame(height: 16)
        .foregroundStyle(player.hasSong ? .grayWhite : asset.playDisableColor)
    }
  }
}

extension LineupMemberCell {
  private var textContents: some View {
    HStack(alignment: .bottom, spacing: 8) {
      Text(player.name)
        .font(.SB5_lineupName)
        .foregroundStyle(.grayWhite)

      Text(player.batThrow.isEmpty ? player.position : "\(player.position), \(player.batThrow)")
        .font(.M5_position)
        .foregroundStyle(asset.positionTextColor)
    }
  }
}
