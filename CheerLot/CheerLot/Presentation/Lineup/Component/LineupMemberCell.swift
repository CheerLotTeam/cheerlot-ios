//
//  LineupMemberCell.swift
//  CheerLot
//
//  Created by 이현주 on 2/19/26.
//

import SwiftUI

/// 라인업 List Cell 입니다.
struct LineupMemberCell: View {
    let asset: LineupAssetVO
    let battingOrder: Int
    let name: String
    let position: String
    let batThrow: String
    let hasSong: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(battingOrder)")
                .font(.M0)
                .foregroundStyle(.grayWhite)
            
            textContents
            
            Spacer()
            
            Image(systemName: "play.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 14)
              .frame(height: 16)
              .foregroundStyle(hasSong ? .grayWhite : asset.playDisableColor)
        }
    }
}

extension LineupMemberCell {
    private var textContents: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(name)
                .font(.SB5_lineupName)
                .foregroundStyle(.grayWhite)
            
            Text("\(position),\(batThrow)")
                .font(.M5_position)
                .foregroundStyle(asset.positionTextColor)
        }
    }
}

#Preview {
    LineupMemberCell(asset: LineupAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)), battingOrder: 1, name: "김선수", position: "포지션", batThrow: "좌타", hasSong: true)
}
