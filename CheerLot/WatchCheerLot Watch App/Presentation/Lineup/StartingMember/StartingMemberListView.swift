//
//  StartingMemberListView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI

struct StartingMemberListView: View {
  @Bindable private var viewModel = StartingMemberListViewModel()
  @State private var isStartViewVisible = true

  var body: some View {
    NavigationStack {
      ZStack {
        ZStack {
          viewModel.currentTheme.watchListBackground
            .resizable()
            .ignoresSafeArea()

          if viewModel.players.isEmpty {
            EmptyListView
          } else {
            List {
              ForEach(viewModel.players, id: \.self) {
                player in
                NavigationLink {
                  LyricsView(players: viewModel.players, initialPlayer: player)
                } label: {
                  Text("\(player.battingOrder)  \(player.name)")
                    .font(.dynamicPretend(type: .semibold, size: 17))
                    .padding(.leading, WatchDynamicLayout.dynamicValuebyWidth(10))
                }
              }
            }
            .navigationTitle(viewModel.lastUpdatedDate)
            .navigationBarTitleDisplayMode(.automatic)
          }
        }

        if isStartViewVisible {
          StartView()
            .onTapGesture {
              withAnimation(.easeOut(duration: 0.8)) {
                isStartViewVisible = false
              }
            }
            .transition(.opacity)
            .zIndex(1)
        }
      }
    }
  }
}

#Preview {
  StartingMemberListView()
}
