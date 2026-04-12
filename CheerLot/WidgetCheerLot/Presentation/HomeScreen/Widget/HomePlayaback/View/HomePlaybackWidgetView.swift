//
//  HomePlaybackWidgetView.swift
//  WidgetCheerLotExtension
//
//  Created by 이승진 on 4/12/26.
//

import SwiftUI
import WidgetKit

// MARK: - Widget View

struct HomePlaybackWidgetView: View {
  let entry: HomePlaybackEntry

  private var asset: WidgetTeamAssetVO {
    WidgetTeamAssetVO(TeamID(entry.teamId))
  }

  private var title: String {
    switch entry.displayState {
    case .team(let teamName, _): teamName
    case .player(let playerName, _): playerName
    }
  }

  private var subtitle: String {
    switch entry.displayState {
    case .team(_, let totalSongCount): totalSongCount > 0 ? "총 \(totalSongCount)곡" : "응원가 재생하기"
    case .player(_, let songTitle): songTitle
    }
  }

  private var deeplink: URL? {
    switch entry.displayState {
    case .team: URL(string: "cheerlot://teamSong")
    case .player: URL(string: "cheerlot://playerSong")
    }
  }

  var body: some View {
    PlaybackStateView
      .widgetURL(deeplink)
  }
}

extension HomePlaybackWidgetView {
  private var PlaybackStateView: some View {
    ZStack {
      asset.primaryColor
      asset.widgetBackgroundGradient.opacity(0.2)

      Image(.teamCardBG)
        .resizable()
        .scaledToFill()
        .clipped()
        .opacity(0.3)
        .blendMode(.softLight)

      contentsView
    }
  }

  private var contentsView: some View {
    VStack(alignment: .leading, spacing: 10) {
      asset.coverImage
        .resizable()
        .scaledToFit()
        .frame(width: 84, height: 84)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(RoundedRectangle(cornerRadius: 12).fill(.white))

      bottomView
    }
  }

  private var bottomView: some View {
    HStack {
      textGroup
      Spacer()
      playImage
    }
    .frame(width: 128)
  }

  private var textGroup: some View {
    VStack(alignment: .leading, spacing: -2) {
      Text(title)
        .font(.SB8)
        .foregroundStyle(.grayWhite)
        .lineLimit(1)

      Text(subtitle)
        .font(.M5)
        .foregroundStyle(asset.primaryPalette.color200)
        .lineLimit(1)
    }
  }

  private var playImage: some View {
    Circle()
      .fill(asset.primaryPalette.color500)
      .frame(width: 32, height: 32)
      .overlay {
        Image(systemName: "play.fill")
          .font(.system(size: 14, weight: .regular))
          .foregroundStyle(.grayWhite)
      }
  }
}
