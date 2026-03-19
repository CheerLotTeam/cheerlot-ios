//
//  LyricsView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/6/25.
//

import SwiftUI

struct LyricsView: View {
  let members: [LineupMemberVO]
  let initialMember: LineupMemberVO
  let asset: WatchTeamAssetVO

  @State private var selectedIndex: Int = 0

  var body: some View {
    TabView(selection: $selectedIndex) {
      ForEach(members.indices, id: \.self) { index in
        let member = members[index]
        Group {
          if !member.cheerSongs.isEmpty {
            LyricsScrollView(member: member)
          } else {
            EmptyCheerSongView
          }
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Text("\(member.name)")
              .foregroundStyle(asset.secondaryColor)
              .font(.SB7)
          }
        }
        .tag(index)
      }
    }
    .tabViewStyle(.verticalPage)
    .onAppear {
      if let index = members.firstIndex(of: initialMember) {
        selectedIndex = index
      }
    }
  }
}

extension LyricsView {
  private func LyricsScrollView(member: LineupMemberVO) -> some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        ForEach(member.cheerSongs, id: \.id) { song in
          VStack(spacing: 4) {
            if member.cheerSongs.count > 1 {
              Text(song.title)
                .font(.R3)
                .foregroundStyle(.gray300)
            }

            Text(song.lyrics)
              .font(.LyricsTypo)
              .foregroundStyle(.grayWhite)
          }
        }
      }
      .padding()
    }
  }

  private var EmptyCheerSongView: some View {
    Text("아직 개인\n응원가가 없어요")
      .font(.SB6)
      .foregroundStyle(.grayWhite)
      .multilineTextAlignment(.center)
  }
}
