//
//  HomeGameInfoMediumWidgetView.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import SwiftUI

struct HomeGameInfoMediumWidgetView: View {
  let entry: TeamGamesEntry

  private var teamAsset: WidgetTeamAssetVO {
    WidgetTeamAssetVO(TeamID(entry.teamId))
  }

  private var opponentTeamAsset: WidgetTeamAssetVO? {
    guard let opponentId = entry.gameSchedule.first?.opponentId else { return nil }
    return WidgetTeamAssetVO(TeamID(opponentId))
  }

  var body: some View {
    switch entry.gameStatus {
    case .teamEmpty:
      TeamEmptyView(isSmallSize: false)
    case .seasonEnded:
      GameInfoView(
        isSmallSize: false, title: "시즌 종료", dateString: entry.date.koreanDateFormatted,
        capsuleTitle: "최근 라인업", asset: teamAsset)
    case .offDay:
      GameInfoView(
        isSmallSize: false, title: "경기 없음", dateString: entry.date.koreanDateFormatted,
        capsuleTitle: "이전 라인업", asset: teamAsset)
    case .playingToday:
      playingTodayView
    }
  }
}

extension HomeGameInfoMediumWidgetView {
  private var playingTodayView: some View {
    ZStack(alignment: .topTrailing) {
      ZStack {
        teamAsset.primaryColor

        teamAsset.widgetBackgroundGradient.opacity(0.2)

        Image(.teamCardBG)
          .resizable()
          .scaledToFill()
          .opacity(0.3)
          .blendMode(.softLight)

        contentsView
      }

      ReloadButton(color: teamAsset.primaryPalette.color200)
        .padding([.top, .trailing], 18)
    }
  }

  private var contentsView: some View {
    VStack(spacing: 4) {
      gameInfoContentsView

      CapsuleBaseView(
        title: "선발 라인업",
        bgColor: teamAsset.primaryPalette.color500
      )
    }
  }

  private var gameInfoContentsView: some View {
    HStack(spacing: 37) {
      teamInfoView(
        asset: teamAsset,
        team: entry.teamLongName,
        pitcher: entry.gameSchedule.first?.starterPitcherName
      )

      dateInfoView

      if let opponentAsset = opponentTeamAsset,
        let opponentLongName = entry.gameSchedule.first?.opponentLongName
      {
        teamInfoView(
          asset: opponentAsset,
          team: opponentLongName,
          pitcher: entry.gameSchedule.first?.opponentStarterPitcherName
        )
      }
    }
  }

  private var dateInfoView: some View {
    VStack(spacing: -6) {
      Text(entry.date.koreanDateFormatted)
        .font(.M5)
        .foregroundStyle(teamAsset.primaryPalette.color200)

      Text("VS")
        .font(.B1)
        .foregroundStyle(.grayWhite)
    }
  }

  private func teamInfoView(asset: WidgetTeamAssetVO, team: String, pitcher: String?) -> some View {
    VStack(spacing: 2) {
      asset.noCoverImage
        .resizable()
        .scaledToFit()
        .frame(width: 56)
        .shadow(color: .white.opacity(0.1), radius: 20, x: 0, y: 0)

      Text(team)
        .font(.SB8)
        .foregroundStyle(.grayWhite)
        .fixedSize()

      if let pitcher {
        HStack(spacing: 2) {
          Image(.pitcher)
            .resizable()
            .scaledToFit()
            .frame(width: 10)

          Text(pitcher)
            .font(.M6)
            .fixedSize()
        }
        .foregroundStyle(teamAsset.primaryPalette.color200)
      }
    }
    .frame(width: 56)
  }
}
