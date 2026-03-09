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
    @State var isPaused: Bool = false
    
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
//        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .strokeBorder(asset.cardStrokeColor, lineWidth: 2)
        )
    }
    
    private var cardContents: some View {
        VStack(alignment: .leading) {
            headerView
            Spacer(minLength: 55)
            lyricsView
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
        }
        .padding(.all, 24)
    }
    
    private var headerView: some View {
        HStack {
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
            .frame(width: 16)
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
                .frame(maxHeight: .infinity, alignment: .bottomLeading)
            
            ScrollView(.vertical) {
                lyricsText
            }
//            .scrollIndicators(.visible)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: 0.85),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
    
    private var lyricsText: some View {
        Text(lyrics)
            .font(.SB2)
            .foregroundStyle(.grayWhite)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    LineupPlayCard()
//}
