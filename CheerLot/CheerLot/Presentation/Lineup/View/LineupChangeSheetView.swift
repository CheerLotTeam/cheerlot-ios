//
//  LineupChangeSheetView.swift
//  CheerLot
//
//  Created by 이현주 on 2/22/26.
//

import SwiftUI

struct LineupChangeSheetView: View {
  let player: PlayerInfo
  let asset: LineupChangeAssetVO
  //      @Environment private var coordinator: AppCoordinator()

  let columns = [
    GridItem(.flexible(), spacing: 23),
    GridItem(.flexible(), spacing: 23),
  ]

  var body: some View {
    VStack(spacing: 18) {
      header
        .padding(.top, 18)

      playerListGrid
    }
    .toolBar_editMode(
      title: "선발 라인업"
    ) {
      //                coordinator.dismissModal()
    } onCheck: {
      // TODO: - 선수교체 로직
      //                coordinator.dismissModal()
    }
  }
}

extension LineupChangeSheetView {
  private var header: some View {
    VStack(spacing: 0) {
      Text("교체 선수")
        .font(.M3)
        .foregroundStyle(.gray300)

      Text(player.name)
        .font(.B3)
        .foregroundStyle(.grayBlack)
    }
  }

  private var playerListGrid: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(0..<30, id: \.self) { _ in
          ChangePlayerSelectCell(
            player: LineupChangeAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)),
            isSelected: true,
            action: {
              // viewModel.select(player.id)
            }
          )
          .frame(height: 60)
        }
      }
      .padding(EdgeInsets(top: 18, leading: 20, bottom: 18, trailing: 20))
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  let cheerSongs: [CheerSongInfo] = [
    CheerSongInfo(
      id: 1, playerId: "1", title: "구자욱 응원가 1", lyrics: "가사 1",
      audioURL: "https://example.com/1.mp3"),
    CheerSongInfo(
      id: 2, playerId: "1", title: "구자욱 응원가 2", lyrics: "가사 2",
      audioURL: "https://example.com/2.mp3"),
  ]

  let player = PlayerInfo(
    id: "1",
    teamId: "samsung",
    name: "구자욱",
    backNumber: 8,
    position: "좌익수",
    batThrow: "좌타",
    battingOrder: 1,
    isStarter: true,
    cheerSongs: cheerSongs
  )

  LineupChangeSheetView(
    player: player,
    asset: LineupChangeAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)))
}
