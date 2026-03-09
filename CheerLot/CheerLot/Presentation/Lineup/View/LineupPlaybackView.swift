//
//  LineupPlaybackView.swift
//  CheerLot
//
//  Created by 이현주 on 3/9/26.
//

import SwiftUI

struct LineupPlaybackView: View {
    let asset: LineupPlaybackAssetVO
    let players: [PlayerInfo]
    
    @State private var scrollPosition: Int?
    @State private var itemsArray: [[PlayerInfo]] = []
    
    private let animationDuration: CGFloat = 0.3
    
    private var pageWidth: CGFloat {
        UIScreen.main.bounds.width - 56
    }
    
    private var pageHeight: CGFloat {
        pageWidth * 1.596
    }
    
    // itemsArray를 평탄화한 전체 아이템
    private var itemsTemp: [PlayerInfo] {
        itemsArray.flatMap { $0 }
    }
    
    // 현재 실제 players 인덱스 (페이지 인디케이터용)
    private var currentRealIndex: Int {
        guard let scrollPosition else { return 0 }
        return scrollPosition % players.count
    }
    
    var body: some View {
        ZStack {
            asset.playbackBackgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 23) {
                cardCarouselView
                    .frame(height: pageHeight)
                
                pageIndicator
            }
        }
    }
}

extension LineupPlaybackView {
    private var cardCarouselView: some View {
        let widthDifference = UIScreen.main.bounds.width - pageWidth
        
        return ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<itemsTemp.count, id: \.self) { index in
                    let player = itemsTemp[index]
                    
                    cardView(player: player, pageHeight: pageHeight)
                        .frame(width: pageWidth)
                        .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.92)
                                .opacity(phase.isIdentity ? 1.0 : 0.3)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(widthDifference / 2, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .scrollIndicators(.hidden)
        .onAppear {
            // 3벌로 초기화, 두번째 벌의 첫번째 아이템에서 시작
            itemsArray = [players, players, players]
            scrollPosition = players.count
        }
        .onChange(of: scrollPosition) {
            guard let scrollPosition else { return }
            
            let itemCount = players.count
            
            // 앞쪽 1/3 영역 진입 시 재배치
            if scrollPosition < itemCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    itemsArray.removeLast()
                    itemsArray.insert(players, at: 0)
                    self.scrollPosition = scrollPosition + itemCount
                }
                return
            }
            
            // 뒤쪽 1/3 영역 진입 시 재배치
            if scrollPosition >= itemCount * 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    itemsArray.removeFirst()
                    itemsArray.append(players)
                    self.scrollPosition = scrollPosition - itemCount
                }
                return
            }
        }
    }
    
    @ViewBuilder
    private func cardView(player: PlayerInfo, pageHeight: CGFloat) -> some View {
        LineupPlayCard(
            asset: asset,
            battingOrder: player.battingOrder ?? 0,
            name: player.name,
            title: player.cheerSongs.first?.title ?? "",
            lyrics: player.cheerSongs.first?.lyrics ?? ""
        )
        .frame(height: pageHeight)
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<players.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentRealIndex ? asset.pageIndicatorColor : .grayWhite)
                    .frame(width: index == currentRealIndex ? 10 : 8, height: index == currentRealIndex ? 10 : 8)
                    .animation(.spring(duration: 0.3), value: currentRealIndex)
            }
        }
        .padding(.all, 1)
    }
}

#Preview {
    let players: [PlayerInfo] = (1...9).map { i in
        PlayerInfo(
            id: PlayerID("\(i)"),
            teamId: "samsung",
            name: "심재훈",
            backNumber: i,
            position: "포지션",
            batThrow: "좌타",
            battingOrder: i,
            cheerSongs: [
                CheerSongInfo(id: "\(i)", playerId: PlayerID("\(i)"), title: "응원가 \(i)", lyrics: "삼성의 심재훈 삼성의 심재훈\n안타를 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n홈런을 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n안타를 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n홈런을 날!려!버!려! 삼성 심재훈", audioURL: "")
            ]
        )
    }
    
    LineupPlaybackView(
        asset: LineupPlaybackAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)),
        players: players
    )
}
