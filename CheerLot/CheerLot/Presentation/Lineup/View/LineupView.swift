//
//  LineupView.swift
//  CheerLot
//
//  Created by 이현주 on 2/5/26.
//

import SwiftUI

struct LineupView: View {
    let asset: LineupAssetVO
    
    var body: some View {
        NavigationStack {
            ScrollView {
                lineupCard
            }
            .safeAreaPadding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .refreshable {
                // TODO: - api 재호출 로직 넣기
            }
            .toolBar_titleWithProfile(title: "선발 라인업") {
                // TODO: - 설정뷰로 가기
            }
        }
    }
}

extension LineupView {
    private var lineupCard: some View {
        ZStack {
            asset.primaryColor
            
            asset.cardBackgroundGradient
                .opacity(0.2)
            
            Image(.teamCardBG)
                .resizable()
                .scaledToFill()
                .opacity(0.75)
                .blendMode(.softLight)
            
            contents
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(asset.cardStrokeColor, lineWidth: 2)
        )
    }
    
    private var contents: some View {
        VStack(spacing: 8) {
            teamName
            
            matchInfo
            
            lineupList
        }
        .padding(.vertical, 20)
    }
    
    private var teamName: some View {
        Text("SAMSUNG LIONS")
            .font(.T1)
            .foregroundStyle(.grayWhite)
            .shadow(
              color: asset.cardTextShadowColor,
              radius: 8,
              x: 0,
              y: 1
            )
    }
    
    private var matchInfo: some View {
        HStack(spacing: 8) {
            Text("12월 12일 | 삼성 vs 기아")
                .font(.M5)
            
            HStack(spacing: 2) {
                Image(systemName: "p.circle.fill")
                    .resizable()
                    .frame(width: 12, height: 12)
                    .scaledToFit()
                    
                Text("원태인")
                    .font(.B4)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(asset.matchInfoBgColor)
        )
        .foregroundColor(.grayWhite)
    }
    
    private var lineupList: some View {
        List {
            ForEach(Array(mockMembers.enumerated()), id: \.element.id) { index, member in
                VStack(spacing: 0) {
                    LineupMemberCell(
                        asset: asset,
                        battingOrder: member.battingOrder,
                        name: member.name,
                        position: member.position,
                        batThrow: member.batThrow,
                        hasSong: member.hasSong
                    )
                    .padding(.horizontal, 5.5)
                    .padding(.vertical, 12)
                    
                    if index < mockMembers.count - 1 {
                        DashedLine()
                            .stroke(
                                style: StrokeStyle(lineWidth: 1, dash: [3])
                            )
                            .foregroundColor(asset.listLineColor)
                            .frame(height: 1)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .lineupCellActions()
            }
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
    }
}

// TODO: 이후 지울 예정
private struct Member: Identifiable {
  let id = UUID()
  let battingOrder: Int
  let name: String
  let position: String
  let batThrow: String
  let hasSong: Bool
}

private let mockMembers: [Member] = [
  Member(battingOrder: 1, name: "김선수", position: "포지션", batThrow: "좌타", hasSong: true),
  Member(battingOrder: 2, name: "이선수", position: "포지션", batThrow: "좌타", hasSong: false),
  Member(battingOrder: 3, name: "박선수", position: "포지션", batThrow: "좌타", hasSong: true),
  Member(battingOrder: 4, name: "최선수", position: "포지션", batThrow: "좌타", hasSong: true),
  Member(battingOrder: 5, name: "김선수", position: "포지션", batThrow: "좌타", hasSong: false),
  Member(battingOrder: 6, name: "이선수", position: "포지션", batThrow: "좌타", hasSong: true),
  Member(battingOrder: 7, name: "박선수", position: "포지션", batThrow: "좌타", hasSong: true),
  Member(battingOrder: 8, name: "김선수", position: "포지션", batThrow: "좌타", hasSong: false),
  Member(battingOrder: 9, name: "최선수", position: "포지션", batThrow: "좌타", hasSong: true)
]

#Preview {
    LineupView(asset: LineupAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)))
}
