//
//  HomeGameScheduleMediumWidgetView.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import SwiftUI
import WidgetKit

struct HomeGameScheduleMediumWidgetView: View {
  let entry: TeamGamesEntry
  @Environment(\.widgetRenderingMode) var renderingMode

  private var asset: WidgetTeamAssetVO {
    WidgetTeamAssetVO(TeamID(entry.teamId))
  }

  var body: some View {
    switch entry.gameStatus {
    case .teamEmpty:
      TeamEmptyView(isSmallSize: false)
    case .seasonEnded:
      GameInfoView(
        isSmallSize: false, title: "시즌 종료", dateString: entry.date.koreanDateFormatted,
        capsuleTitle: "최근 라인업", asset: asset)
    default:
      notSeasonOutView
    }
  }
}

extension HomeGameScheduleMediumWidgetView {
  private var notSeasonOutView: some View {
    ZStack {
        if renderingMode != .accented {
            asset.widgetBackgroundGradient.opacity(0.2)
        }
      notSeasonOutContentsView
    }
  }

  private var todayDateTextView: some View {
    VStack(spacing: -2) {
      Text(entry.date.dayOfWeek)
        .font(.M5)
        .foregroundStyle(.gray100)
        .widgetAccentable()

      Text(entry.date.dayOfMonth)
        .font(.B3)
        .foregroundStyle(.grayWhite)
        .widgetAccentable()
    }
  }

  private var todayContentsView: some View {
    VStack(spacing: 21) {
      todayDateTextView

      asset.noCoverImage
        .resizable()
        .widgetAccentedRenderingMode(.fullColor)
        .scaledToFit()
        .frame(width: 60)
        .shadow(color: Color.white.opacity(0.15), radius: 20, x: 0, y: 0)
    }
    .frame(width: 60)
  }

  private var gameScheduleView: some View {
    LazyVStack(spacing: 6) {
      ForEach(Array(entry.gameSchedule.enumerated()), id: \.offset) { index, game in
        GameScheduleCell(team: entry.teamId, game: game, asset: asset, isToday: index == 0)
          .frame(maxWidth: .infinity)
      }
    }
    .frame(maxWidth: .infinity)
  }

  private var notSeasonOutContentsView: some View {
    HStack(spacing: 13) {
      todayContentsView

      gameScheduleView
    }
    .padding(18)
  }
}
