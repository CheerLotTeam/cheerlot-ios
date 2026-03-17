//
//  TeamSelectCell.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

import SwiftUI

/// 팀 선택 뷰에서의 팀 Cell입니다.
struct TeamSelectCell: View {
  let team: TeamSelectVO
  let isSelected: Bool
  let action: () -> Void

  private var asset: TeamAssetVO {
    TeamAssetVO(TeamID(team.id))
  }

  var body: some View {
    Button {
      action()
    } label: {
      buttonContents
    }
    .buttonStyle(.plain)
  }
}

extension TeamSelectCell {
  private var textContents: some View {
    VStack(alignment: .center, spacing: 7.5) {
      Text(team.englishFullName)
        .font(.T3)
        .multilineTextAlignment(.center)

      Text(team.longName)
        .font(.SB9)
    }
    .foregroundStyle(isSelected ? .grayWhite : .gray300)
  }

  private var buttonContents: some View {
    textContents
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(isSelected ? asset.primaryColor : .grayWhite)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(
            isSelected ? asset.primaryColor : .gray100,
            lineWidth: 1
          )
      )
  }
}
