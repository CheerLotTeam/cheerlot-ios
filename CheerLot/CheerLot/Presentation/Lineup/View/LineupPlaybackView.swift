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
    let startIndex: Int
    
    @State private var scrollPosition: Int?
    @State private var itemsArray: [[CarouselItem]] = []
    @State private var isRebalancing: Bool = false
    
    private let animationDuration: CGFloat = 0.3
    
    private var pageWidth: CGFloat {
        UIScreen.width - 56
    }
    
    private var pageHeight: CGFloat {
        pageWidth * 1.596
    }
    
    private var carouselItems: [CarouselItem] {
        players.flatMap { player in
            player.cheerSongs.map { song in
                CarouselItem(id: "\(player.id)-\(song.id)", player: player, cheerSong: song)
            }
        }
    }
    
    // itemsArray를 평탄화한 전체 아이템
    private var itemsTemp: [CarouselItem] {
        itemsArray.flatMap { $0 }
    }
    
    // 현재 실제 players 인덱스 (페이지 인디케이터용)
    private var currentRealIndex: Int {
        guard let scrollPosition else { return 0 }
        guard !carouselItems.isEmpty else { return 0 }
        return scrollPosition % carouselItems.count
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
        let widthDifference = UIScreen.width - pageWidth
        
        return ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(0..<itemsTemp.count, id: \.self) { index in
                    let item = itemsTemp[index]
                    
                    cardView(item: item, pageHeight: pageHeight)
                        .id("\(index)-\(item.id)")
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
            itemsArray = [carouselItems, carouselItems, carouselItems]
            scrollPosition = carouselItems.count + startIndex
        }
        .onChange(of: scrollPosition) {
            guard let scrollPosition, !isRebalancing else { return }
            
            let itemCount = carouselItems.count
            guard itemCount > 0 else { return }
            
            // 앞쪽 1/3 영역 진입 시 재배치
            if scrollPosition < itemCount {
                isRebalancing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    itemsArray.removeLast()
                    itemsArray.insert(carouselItems, at: 0)
                    self.scrollPosition = scrollPosition + itemCount
                    self.isRebalancing = false
                }
                return
            }
            
            // 뒤쪽 1/3 영역 진입 시 재배치
            if scrollPosition >= itemCount * 2 {
                isRebalancing = true
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    itemsArray.removeFirst()
                    itemsArray.append(carouselItems)
                    self.scrollPosition = scrollPosition - itemCount
                    self.isRebalancing = false
                }
                return
            }
        }
    }
    
    @ViewBuilder
    private func cardView(item: CarouselItem, pageHeight: CGFloat) -> some View {
        LineupPlayCard(
            asset: asset,
            battingOrder: item.player.battingOrder ?? 0,
            name: item.player.name,
            title: item.cheerSong.title,
            lyrics: item.cheerSong.lyrics
        )
        .frame(height: pageHeight)
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<carouselItems.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentRealIndex ? asset.pageIndicatorColor : .grayWhite)
                    .frame(width: index == currentRealIndex ? 10 : 8, height: index == currentRealIndex ? 10 : 8)
                    .animation(.spring(duration: 0.3), value: currentRealIndex)
            }
        }
        .padding(.all, 1)
    }
}

extension LineupPlaybackView {
    private struct CarouselItem: Identifiable {
        let id: String
        let player: PlayerInfo
        let cheerSong: CheerSongInfo
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
                CheerSongInfo(id: "\(i)", playerId: PlayerID("\(i)"), title: "응원가 \(i)", lyrics: "삼성의 심재훈 삼성의 심재훈\n안타를 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n홈런을 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n안타를 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n홈런을 날!려!버!려! 삼성 심재훈", audioURL: ""),
                CheerSongInfo(id: "\(i)", playerId: PlayerID("\(i)"), title: "응원가 \(i)", lyrics: "삼성의 심재훈 삼성의 심재훈\n안타를 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n홈런을 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n안타를 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n홈런을 날!려!버!려! 삼성 심재훈", audioURL: "")
            ]
        )
    }
    
    LineupPlaybackView(
        asset: LineupPlaybackAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)),
        players: players, startIndex: 2
    )
}
