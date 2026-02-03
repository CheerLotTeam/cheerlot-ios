//
//  TeamMembersCell.swift
//  CheerLot
//
//  Created by 이승진 on 2/2/26.
//

import SwiftUI

/// 전체 선수 List Cell 입니다.
struct TeamMembersCell: View {
  
  // MARK: - Properties
  let asset: TeamMembersAssetVO
  let memberName: String
  let hasSong: Bool
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
        .offset(y: -2)
      
      Spacer()
      
      Image(systemName: "play.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 14)
        .frame(height: 16)
        .foregroundStyle(hasSong ? asset.primaryColor : .gray200)
    }
    .padding(.bottom, 12)
    .padding(.horizontal, 10)
  }
}

#Preview {
  TeamMembersCell(
    asset: TeamMembersAssetVO(
      team: TeamDataSource.toEntity(.samsung)
    ),
    memberName: "김선수",
    hasSong: true,
    backNumber: 23
  )
  .padding()
}
