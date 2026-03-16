//
//  LineupCellActionsModifier.swift
//  CheerLot
//
//  Created by 이현주 on 2/19/26.
//

import SwiftUI

struct LineupCellActionsModifier: ViewModifier {
  let player: LineupPlayerVO
  let onChangePlayer: () -> Void
  let onSelectSong: (CheerSongVO) -> Void

  func body(content: Content) -> some View {
    content
      .swipeActions(edge: .trailing) {
        Button {
          onChangePlayer()
        } label: {
          Image(.changeIcon)
        }
        .tint(.change)
      }
      .contextMenu {
        Button {
          onChangePlayer()
        } label: {
          Label("교체", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
        }

        if player.hasSong {
          ForEach(player.cheerSongs) { cheerSong in
            Button {
              onSelectSong(cheerSong)
            } label: {
              Label(cheerSong.title, systemImage: "play.fill")
            }
          }
        }
      }
  }
}
