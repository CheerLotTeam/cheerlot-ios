//
//  LineupView.swift
//  CheerLot
//
//  Created by 이현주 on 2/5/26.
//

import SwiftUI

struct LineupView: View {
    let asset: LineupAssetVO
    let gameInfo: GameStatus
    // TODO: - UserDefaults로 저장할 것.
    @State private var showLineup: Bool = false
//    @Environment private var coordinator: AppCoordinator()
    
    // MARK: - Layout Constants
    private let teamNameHeight: CGFloat = 44.5
    private let matchInfoHeight: CGFloat = 26.5
    private let cardTopPadding: CGFloat = 20
    private let cardBottomPadding: CGFloat = 10
    private let cardSpacing: CGFloat = 8
    private let separatorHeight: CGFloat = 1
    private let safeAreaVerticalPadding: CGFloat = 10
    private let safeAreaHorizontalPadding: CGFloat = 20
    
    var body: some View {
        GeometryReader { geo in
            let cardHeight = max(0, geo.size.height - safeAreaVerticalPadding * 2)
            let cardWidth = max(0, geo.size.width - safeAreaHorizontalPadding * 2)

            ScrollView {
                lineupCard(cardHeight: cardHeight, cardWidth: cardWidth)
            }
            .frame(width: geo.size.width)
            .scrollIndicators(.hidden)
            .refreshable {
                // TODO: - api 재호출 로직 넣기
            }
            .toolBar_titleWithProfile(title: "선발 라인업") {
              // coordinator.push(.settings)
            }
        }
    }
    
    // MARK: - Height 계산
    private func listHeight(cardHeight: CGFloat) -> CGFloat {
        max(0, cardHeight - teamNameHeight - matchInfoHeight - cardTopPadding - cardBottomPadding - cardSpacing * 2)
    }

    private func cellHeight(cardHeight: CGFloat) -> CGFloat {
        let totalSeparatorHeight = separatorHeight * CGFloat(mockMembers.count - 1)
        let availableHeight = listHeight(cardHeight: cardHeight) - totalSeparatorHeight
        return max(0, availableHeight / CGFloat(mockMembers.count))
    }
    
    private func noGameMessage(for status: GameStatus) -> String {
        switch status {
        case .offDay:      return "오늘은 경기가 없는 날이에요"
        case .seasonEnded: return "다음 시즌 준비중이에요"
        case .playingToday: return ""
        }
    }
}

extension LineupView {
    private func lineupCard(cardHeight: CGFloat, cardWidth: CGFloat) -> some View {
        ZStack {
            asset.primaryColor

            asset.cardBackgroundGradient
                .opacity(0.2)

            Image(.teamCardBG)
                .resizable()
                .scaledToFill()
                .opacity(0.75)
                .blendMode(.softLight)

            contents(cardHeight: cardHeight, cardWidth: cardWidth)
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(asset.cardStrokeColor, lineWidth: 2)
        )
    }
    
    private func contents(cardHeight: CGFloat, cardWidth: CGFloat) -> some View {
        ZStack {
            VStack(spacing: cardSpacing) {
                teamName
                matchInfo
                
                if gameInfo == .playingToday || showLineup {
                    lineupList(cardHeight: cardHeight, cardWidth: cardWidth)
                }
            }
            .padding(.top, cardTopPadding)
            .padding(.bottom, cardBottomPadding)
            .frame(maxHeight: .infinity, alignment: .top) // header 상단 고정
            
            if gameInfo != .playingToday && !showLineup {
                hasNoGameView(status: gameInfo)
            }
        }
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
                .font(.M5_gameState)
            
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
        .background(Capsule().fill(asset.matchInfoBgColor))
        .foregroundColor(.grayWhite)
    }
    
    private func lineupList(cardHeight: CGFloat, cardWidth: CGFloat) -> some View {
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
                    .frame(height: cellHeight(cardHeight: cardHeight))
                    .padding(.horizontal, 5.5)

                    if index < mockMembers.count - 1 {
                        DashedLine()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .foregroundColor(asset.listLineColor)
                            .frame(height: separatorHeight)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .lineupCellActions()
            }
        }
        .frame(width: cardWidth, height: listHeight(cardHeight: cardHeight))
        .listStyle(.plain)
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
        .clipShape(Rectangle())
        .contentShape(Rectangle())
    }
    
    private func hasNoGameView(status: GameStatus) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text(noGameMessage(for: status))
                .font(.M3)
                .foregroundStyle(asset.positionTextColor)
            
            Button {
                showLineup = true
            } label: {
                Text("최근 경기 라인업 보기")
                    .font(.SB8)
                    .foregroundStyle(.grayWhite)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        ZStack {
                            asset.primaryColor
                            asset.lastestGameButtonGradient.opacity(0.2)
                            asset.positionTextColor.opacity(0.2)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(asset.lastestGameButtonStrokeColor, lineWidth: 1.5)
                    )
            }
            Spacer()
        }
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
    NavigationStack {
        LineupView(asset: LineupAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)), gameInfo: .offDay)
    }
}
