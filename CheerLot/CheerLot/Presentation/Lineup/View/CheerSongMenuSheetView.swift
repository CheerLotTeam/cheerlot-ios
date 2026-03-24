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
        .padding(.top, 34)

      CheerSongListView
    }
    .appBackground()
  }

  private var CheerSongListView: some View {
    List {
      // 응원가가 2개 이상일 경우에만 나오는 sheetView이므로 강제 언래핑
      ForEach(Array(player.cheerSongs.enumerated()), id: \.element.id) { _, cheerSong in
        VStack(spacing: 28) {
          Divider()
            .foregroundStyle(.gray000)

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
    .scrollContentBackground(.hidden)
    .scrollDisabled(true)
  }
}

extension CheerSongMenuSheetView {
  private func handleSongSelection(_ selectedSong: CheerSongVO) {
    let selectedIndex =
      lineupPlayers
      .flatMap { $0.cheerSongs }
      .firstIndex { $0.id == selectedSong.id } ?? 0

    coordinator.dismissModal()
    coordinator.presentModal(.lineupPlayback(startIndex: selectedIndex))

  }
}

#Preview {

}
