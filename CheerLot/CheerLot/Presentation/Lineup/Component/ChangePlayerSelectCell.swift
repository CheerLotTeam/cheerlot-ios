//
//  ChangePlayerSelectCell.swift
//  CheerLot
//
//  Created by 이현주 on 2/23/26.
//

import SwiftUI

struct ChangePlayerSelectCell: View {
  let player: LineupPlayerVO
  let asset: LineupChangeAssetVO
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
    Text("\(player.name)")
      .font(.SB5)
      .foregroundStyle(isSelected ? asset.primaryColor : .gray500)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(isSelected ? asset.selectedCellFillColor : .grayWhite)
          .shadow(
            color: isSelected ? asset.cellShadowColor : .gray500.opacity(0.15),
            radius: 4,
            x: 0,
            y: 0
          )
      )
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .strokeBorder(
            isSelected ? asset.selectedCellStrokeColor : .grayWhite,
            lineWidth: 1.5
          )
      )
  }
}
