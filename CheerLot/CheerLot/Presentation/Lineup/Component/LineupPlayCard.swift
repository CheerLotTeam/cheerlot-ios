//
//  LineupPlayCard.swift
//  CheerLot
//
//  Created by 이현주 on 3/9/26.
//

import SwiftUI

struct LineupPlayCard: View {
    let asset: LineupPlaybackAssetVO
    let battingOrder: Int
    let name: String
    let title: String
    let lyrics: String
    var playCardImage: Image? {
        asset.playCardImage(for: battingOrder)
    }
    
    @State private var isPaused: Bool = false
    @State private var isScrolledToBottom: Bool = false
    
    var body: some View {
        Button {
            isPaused.toggle()
        } label: {
            cardView
        }
    }
}

extension LineupPlayCard {
    private var cardView: some View {
        ZStack {
          asset.primaryColor

          asset.cardBackgroundGradient
            .opacity(0.2)

          if let image = playCardImage {
            image
              .resizable()
              .scaledToFill()
              .opacity(0.75)
              .blendMode(.softLight)
          }
            
          cardContents
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .strokeBorder(asset.cardStrokeColor, lineWidth: 2)
        )
    }
    
    private var cardContents: some View {
        VStack {
            headerView
            Spacer(minLength: 55)
            lyricsView
        }
        .padding(.all, 24)
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            cheerSongInfoView
            
            Spacer()
            
            Group {
                isPaused
                ? Image(systemName: "pause.fill")
                    .resizable()
                : Image(systemName: "play.fill")
                    .resizable()
            }
            .scaledToFit()
            .frame(width: isPaused ? 13 : 15)
            .foregroundStyle(asset.cardContentsColor)
        }
    }
    
    private var cheerSongInfoView: some View {
        HStack(spacing: 6) {
            Text("\(battingOrder)")
                .font(.SB1)
                .foregroundStyle(asset.battingOrderTextColor)
            
            VStack(alignment: .leading, spacing: 0) {
              Text(name)
                .font(.SB3)
                .foregroundStyle(.grayWhite)
                
              Text(title)
                .font(.R2)
                .foregroundStyle(asset.cardContentsColor)
            }
        }
    }
    
    private var lyricsView: some View {
        ViewThatFits(in: .vertical) {
            lyricsText
            
            ScrollView(.vertical) {
                lyricsText
            }
            .scrollIndicators(.hidden)
            .onScrollGeometryChange(for: Bool.self) { geo in
                geo.contentOffset.y >= geo.contentSize.height - geo.containerSize.height - 1
            } action: { _, isBottom in
                isScrolledToBottom = isBottom
            }
            .mask(
                Group {
                    if isScrolledToBottom {
                        Color.black  // 완전히 보임
                    } else {
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.85),
                                .init(color: .clear, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                }
            )
        }
    }
    
    private var lyricsText: some View {
        Text(lyrics)
            .font(.SB2)
            .foregroundStyle(.grayWhite)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LineupPlayCard(asset: LineupPlaybackAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)), battingOrder: 1, name: "구자욱", title: "기본 응원가", lyrics: "삼성의 심재훈 삼성의 심재훈\n안타를 날!려!버!려! 삼성 심재훈\n삼성의 심재훈 삼성의 심재훈\n홈런을 날!려!버!려! 삼성 심재훈")
        .frame(width: 337, height: 538)
}
