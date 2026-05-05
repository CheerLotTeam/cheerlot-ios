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
  let isCompact: Bool

  var body: some View {
    HStack(spacing: 12) {
      if let battingOrder = player.battingOrder {
        Text("\(battingOrder)")
          .font(isCompact ? .M0_lineupCompact : .M0)
          .foregroundStyle(asset.battingOrderTextColor)
      }

      textContents

      Spacer()

      Image(systemName: "play.fill")
        .resizable()
        .scaledToFit()
        .frame(width: isCompact ? 10 : 12)
        .foregroundStyle(player.hasSong ? .grayWhite : asset.playDisableColor)
    }
    .frame(maxHeight: .infinity)
  }
}

extension LineupMemberCell {
  private var textContents: some View {
    HStack(alignment: .bottom, spacing: 8) {
      Text(player.name)
        .font(isCompact ? .SB5_lineupNameCompact : .SB5_lineupName)
        .foregroundStyle(.grayWhite)

      Text(player.batThrow.isEmpty ? player.position : "\(player.position), \(player.batThrow)")
        .font(isCompact ? .M5_positionCompact : .M5_position)
        .foregroundStyle(asset.positionTextColor)
    }
  }
}
