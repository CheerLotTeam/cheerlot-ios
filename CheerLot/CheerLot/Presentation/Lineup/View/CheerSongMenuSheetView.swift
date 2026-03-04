//
//  CheerSongMenuSheetView.swift
//  CheerLot
//
//  Created by 이현주 on 6/1/25.
//

import SwiftUI

struct CheerSongMenuSheetView: View {
  let asset: TeamAssetVO
  let player: LineupPlayerVO
  let lineupPlayers: [LineupPlayerVO]

  @Environment(AppCoordinator.self) private var coordinator

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
          handleSongSelection(cheerSong)
        }
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
    }
    .listStyle(.plain)
    .scrollDisabled(true)
  }
}

extension CheerSongMenuSheetView {
  private func handleSongSelection(_ selectedSong: CheerSongVO) {
    // 1. 모든 응원가 수집
    let allCheerSongs = lineupPlayers.flatMap { $0.cheerSongs }

    // 2. 선택된 응원가의 인덱스 찾기
    guard let selectedIndex = allCheerSongs.firstIndex(where: { $0.id == selectedSong.id }) else {
      return
    }

    // 3. Sheet 닫기
    coordinator.dismissModal()

    // TODO: Playback 화면으로 이동
    // coordinator.presentModal(.playback(player: playerVO, songIndex: selectedIndex))

  }
}

#Preview {

}
