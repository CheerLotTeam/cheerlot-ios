//
//  LineupView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/18/26.
//

import SwiftUI

struct LineupView: View {
    @State private var isPresented = true
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.players.isEmpty {
                    EmptyListView
                } else {
                    MemberListView
                        .navigationTitle(viewModel.lastUpdatedDate)
                        .navigationBarTitleDisplayMode(.automatic)
                }
            }
            .sheet(isPresented: $isPresented) {
                WatchOnboardingView()
            }
        }
    }
}

extension LineupView {
    private var MemberListView: some View {
        List {
          ForEach(viewModel.players, id: \.self) {
            player in
            NavigationLink {
              LyricsView(players: viewModel.players, initialPlayer: player)
            } label: {
                HStack(spacing: 6) {
                    Text("\(player.battingOrder)")
                        .font(.SB6)
                    
                    Text(player.name)
                        .font(.SB7)
                }
                .padding(.leading, 7.5)
            }
          }
        }
    }
    
    private var EmptyListView: some View {
        ZStack {
            // TODO: - 그라디언트 백그라운드
            
            VStack(spacing: 2) {
                Text("선수 명단이 없어요")
                    .font(.SB7)
                    .foregroundStyle(.grayWhite)
                
                Text("iPhone 앱을 새로고침해 주세요")
                    .font(.M6)
                    .foregroundStyle(.gray200)
            }
        }
    }
}

#Preview {
    LineupListView()
}
