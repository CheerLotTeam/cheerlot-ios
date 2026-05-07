//
//  HomeGameInfoSmallWidgetView.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import SwiftUI

struct HomeGameInfoSmallWidgetView: View {
  let entry: TeamGamesEntry

  private var dateString: String {
    entry.date.koreanDateFormatted
  }

  private var asset: WidgetTeamAssetVO {
    WidgetTeamAssetVO(TeamID(entry.teamId))
  }

  var body: some View {
    if entry.gameStatus == .teamEmpty {
      TeamEmptyView(isSmallSize: true)
    } else {
      let isHome = entry.gameSchedule.first?.isHome == true
      let opponent = entry.gameSchedule.first?.opponentShortName ?? ""
      let title: String =
        switch entry.gameStatus {
        case .playingToday:
          "\(isHome ? opponent : entry.teamShortName) vs \(isHome ? entry.teamShortName : opponent)"
        case .offDay: "경기 없음"
        case .seasonEnded: "시즌 종료"
        case .teamEmpty: ""
        }
      let capsuleTitle: String =
        switch entry.gameStatus {
        case .playingToday: "선발 라인업"
        case .offDay: "이전 라인업"
        case .seasonEnded: "최근 라인업"
        case .teamEmpty: ""
        }

      GameInfoView(
        isSmallSize: true, title: title, dateString: dateString, capsuleTitle: capsuleTitle,
        asset: asset)
    }
  }
}
