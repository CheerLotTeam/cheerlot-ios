//
//  SearchResultCell.swift
//  CheerLot
//
//  Created by 이승진 on 3/1/26.
//

import SwiftUI

/// 선수 검색 결과 List Cell 입니다.
struct SearchResultCell: View {

  // MARK: - Properties
  let asset: SearchAssetVO
  let memberName: String
  let hasSong: Bool
  let title: String?
  let backNumber: Int

  // MARK: - Body
  var body: some View {
    HStack(spacing: 3) {
      Text(memberName)
        .font(.SB4)
        .foregroundStyle(.grayBlack)

      Text("\(backNumber)")
        .font(.M3)
        .foregroundStyle(.gray400)
        .offset(y: -4)

      Spacer()
      
      HStack(spacing: 16) {
        if let title {
          Text(title)
            .font(.M4)
            .foregroundStyle(.gray300)
        }
        
        Image(systemName: "play.fill")
          .font(.system(size: 16, weight: .regular))
          .foregroundStyle(hasSong ? asset.primaryColor : .gray200)
      }
    }
    .padding(.bottom, 24)
    .padding(.horizontal, 10)
  }
}

#Preview {
  SearchResultCell(
    asset: SearchAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)),
    memberName: "김선수",
    hasSong: true,
    title: "",
    backNumber: 23
  )
}
