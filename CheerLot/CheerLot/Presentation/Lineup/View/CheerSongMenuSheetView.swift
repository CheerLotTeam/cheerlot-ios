//
//  CheerSongMenuSheetView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct CheerSongMenuSheetView: View {
  let asset: TeamAssetVO
  let player: PlayerInfo
  let lineupPlayer: [PlayerInfo]

  //  @Environment private var coordinator: AppCoordinator()

  var body: some View {
    VStack(spacing: 28) {
      Text(player.name)
        .font(.SB5)
        .foregroundStyle(Color.black)
        .padding(.top, 23)

      CheerSongListView
    }
  }

  private var CheerSongListView: some View {
    List {
      // 응원가가 2개 이상일 경우에만 나오는 sheetView이므로 강제 언래핑
      ForEach(Array(player.cheerSongs.enumerated()), id: \.element.id) { _, cheerSong in
        VStack(spacing: 28) {
          Divider()
            .foregroundStyle(.gray100)

          Text(cheerSong.title)
            .font(.SB5)
            .foregroundStyle(asset.primaryColor)
            .padding(.bottom, 28)
        }
        .contentShape(Rectangle())
        .onTapGesture {
          //              coordinator.dismissModal()

          let allCheerSongs = lineupPlayer.flatMap { $0.cheerSongs }
          guard let selectedIndex = allCheerSongs.firstIndex(where: { $0.id == cheerSong.id })
          else { return }

          // TODO: coordinator로 playback 화면 push
          // coordinator.presentModal(.playback(player: currentPlayer, songIndex: selectedIndex))
        }
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
    }
    .listStyle(.plain)
    .scrollDisabled(true)
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

  let lineupPlayers: [PlayerInfo] = [
    player,
    PlayerInfo(
      id: "2", teamId: "samsung", name: "이재현", backNumber: 2, position: "유격수", batThrow: "우타",
      battingOrder: 2, isStarter: true,
      cheerSongs: [
        CheerSongInfo(
          id: 3, playerId: "2", title: "이재현 응원가", lyrics: "가사 3",
          audioURL: "https://example.com/3.mp3")
      ]
    ),
  ]

  CheerSongMenuSheetView(
    asset: TeamAssetVO(TeamDataSource.toEntity(.samsung).id),
    player: player,
    lineupPlayer: lineupPlayers
  )
}
