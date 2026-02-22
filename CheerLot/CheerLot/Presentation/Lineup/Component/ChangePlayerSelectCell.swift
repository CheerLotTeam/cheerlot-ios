//
//  ChangePlayerSelectCell.swift
//  CheerLot
//
//  Created by 이현주 on 2/23/26.
//

import SwiftUI

struct ChangePlayerSelectCell: View {
  let player: LineupChangeAssetVO
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button {
      action()
    } label: {
      buttonContents
    }
    .buttonStyle(.plain)
  }
}

extension ChangePlayerSelectCell {
  private var buttonContents: some View {
    Text("김선수")
      .font(.SB5)
      .foregroundStyle(isSelected ? player.primaryColor : .grayBlack)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(isSelected ? player.selectedCellFillColor : .grayWhite)
          .shadow(
            color: player.cellShadowColor,
            radius: 4,
            x: 0,
            y: 0
          )
      )
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .strokeBorder(
            isSelected ? player.selectedCellStrokeColor : .grayWhite,
            lineWidth: 1.5
          )
      )
  }
}

#Preview {
  ChangePlayerSelectCell(
    player: LineupChangeAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)),
    isSelected: true,
    action: {
    })
}
