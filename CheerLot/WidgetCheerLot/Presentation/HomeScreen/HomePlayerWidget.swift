//
//  HomePlayerWidget.swift
//  WidgetCheerLot
//
//  Created by 이승진 on 4/3/26.
//

import SwiftUI
import WidgetKit

// MARK: - Entry

struct HomePlayerEntry: TimelineEntry {
  let date: Date
  let displayState: DisplayState

  enum DisplayState {
    /// 백그라운드 X: 선택된 팀 전체리스트 첫 곡 재생
    case team(teamId: String, teamName: String, totalSongCount: Int)
    /// 백그라운드 O: 해당 선수 재생뷰로 이동
    case player(teamId: String, playerName: String)
  }
}

// MARK: - Provider

struct HomePlayerProvider: TimelineProvider {
  func placeholder(in context: Context) -> HomePlayerEntry {
    HomePlayerEntry(
      date: .now,
      displayState: .team(teamId: "SAMSUNG", teamName: "삼성 라이온즈", totalSongCount: 30)
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (HomePlayerEntry) -> Void) {
    completion(
      HomePlayerEntry(
        date: .now,
        displayState: .team(teamId: "SAMSUNG", teamName: "삼성 라이온즈", totalSongCount: 30)
      )
    )
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<HomePlayerEntry>) -> Void
  ) {
    let entry = fetchEntry()
    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
    completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
  }

  private func fetchEntry() -> HomePlayerEntry {
    guard
      let defaults = UserDefaults(suiteName: AppGroup.id),
      let teamId = defaults.string(forKey: UserDefaultsKey.selectedTeamId)
    else {
      return HomePlayerEntry(date: .now, displayState: .team(teamId: "SAMSUNG", teamName: "삼성", totalSongCount: 0))
    }

    let asset = HomeTeamAssetVO(base: WidgetTeamAssetVO(teamId))
    let playerName = defaults.string(forKey: UserDefaultsKey.Widget.playerName)

    if let playerName {
      return HomePlayerEntry(
        date: .now,
        displayState: .player(teamId: teamId, playerName: playerName)
      )
    } else {
      let songCount = defaults.integer(forKey: UserDefaultsKey.Widget.totalSongCount)
      let teamName = asset.shortName
      return HomePlayerEntry(
        date: .now,
        displayState: .team(teamId: teamId, teamName: teamName, totalSongCount: songCount)
      )
    }
  }
}

// MARK: - View

struct HomePlayerWidgetView: View {
  let entry: HomePlayerEntry

  var body: some View {
    switch entry.displayState {
    case .team(let teamId, let teamName, let totalSongCount):
      TeamStateView(
        asset: HomeTeamAssetVO(base: WidgetTeamAssetVO(teamId)),
        teamName: teamName,
        totalSongCount: totalSongCount
      )
      .widgetURL(URL(string: "cheerlot://teamSong"))

    case .player(let teamId, let playerName):
      PlayerStateView(
        asset: HomeTeamAssetVO(base: WidgetTeamAssetVO(teamId)),
        playerName: playerName
      )
      .widgetURL(URL(string: "cheerlot://playerSong"))
    }
  }
}

// MARK: - TeamStateView

private struct TeamStateView: View {
  let asset: HomeTeamAssetVO
  let teamName: String
  let totalSongCount: Int

  var body: some View {
    ZStack {
      asset.primaryColor

      asset.widgetBackgroundGradient
        .opacity(0.2)

      Image("teamCardBG")
        .resizable()
        .scaledToFill()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .opacity(0.5)
        .blendMode(.softLight)

      VStack(alignment: .leading, spacing: 0) {
        asset.coverImage
          .resizable()
          .scaledToFit()
          .frame(width: 84, height: 84)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .background(RoundedRectangle(cornerRadius: 12).fill(.white))

        Spacer()

        HStack(alignment: .bottom) {
          VStack(alignment: .leading, spacing: 0) {
            Text(teamName)
              .font(.SB8)
              .foregroundStyle(.grayWhite)
              .lineLimit(1)

            Text("총 \(totalSongCount)곡")
              .font(.M5)
              .foregroundStyle(asset.primaryPalette.color200)
          }

          Spacer()

          PlayButton()
        }
      }
      .padding(14)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
  }
}

// MARK: - PlayerStateView

private struct PlayerStateView: View {
  let asset: HomeTeamAssetVO
  let playerName: String

  var body: some View {
    ZStack {
      asset.primaryColor

      asset.widgetBackgroundGradient
        .opacity(0.2)

      Image("teamCardBG")
        .resizable()
        .scaledToFill()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .opacity(0.5)
        .blendMode(.softLight)

      VStack(alignment: .leading, spacing: 0) {
        asset.coverImage
          .resizable()
          .scaledToFit()
          .frame(width: 84, height: 84)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .background(RoundedRectangle(cornerRadius: 12).fill(.white))

        Spacer()

        HStack(alignment: .bottom) {
          VStack(alignment: .leading, spacing: 0) {
            Text(playerName)
              .font(.SB8)
              .foregroundStyle(.grayWhite)
              .lineLimit(1)

            Text("기본 응원가")
              .font(.M5)
              .foregroundStyle(asset.primaryPalette.color200)
          }

          Spacer()

          PlayButton()
        }
      }
      .padding(14)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
  }
}

// MARK: - PlayButton

private struct PlayButton: View {
  var body: some View {
    Circle()
      .fill(.white.opacity(0.25))
      .frame(width: 36, height: 36)
      .overlay {
        Image(systemName: "play.fill")
          .font(.system(size: 14))
          .foregroundStyle(.white)
          .offset(x: 1)
      }
  }
}

// MARK: - Widget

struct HomePlayerWidget: Widget {
  let kind: String = "HomePlayerWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: HomePlayerProvider()) { entry in
      HomePlayerWidgetView(entry: entry)
        .containerBackground(Color.clear, for: .widget)
    }
    .configurationDisplayName("응원가 플레이어")
    .description("응원가를 홈화면에서 바로 재생하세요.")
    .supportedFamilies([.systemSmall])
  }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
  HomePlayerWidget()
} timeline: {
  HomePlayerEntry(date: .now, displayState: .team(teamId: "SAMSUNG", teamName: "삼성 라이온즈", totalSongCount: 30))
  HomePlayerEntry(date: .now, displayState: .player(teamId: "SAMSUNG", playerName: "김선수"))
}
