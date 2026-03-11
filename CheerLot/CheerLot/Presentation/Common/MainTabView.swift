//
//  MainTabView.swift
//  CheerLot
//
//  Created by 이현주 on 1/29/26.
//

import SwiftUI

enum TabKey {
  case lineup, teamMembers, search
}

struct MainTabView: View {

  // MARK: - Properties
  let team: TeamInfo
  let audioPlayer: AudioPlaybackService

  @State private var selectedTab: TabKey = .lineup
  @State private var isPlayerExpanded: Bool = false
  @State private var lineupViewModel = ViewModelFactory.shared.createLineupViewModel()
  @State private var teamMembersViewModel = ViewModelFactory.shared.createTeamMembersViewModel()

  @Namespace private var animation

  private var asset: TeamAssetVO {
    TeamAssetVO(team.id)
  }

  private var showMiniPlayer: Bool {
    selectedTab != .lineup && audioPlayer.nowPlaying != nil
  }

  // MARK: - Init
  init(team: TeamInfo, audioPlayer: AudioPlaybackService) {
    self.team = team
    self.audioPlayer = audioPlayer

    // TabBar 스타일 설정
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }

  // MARK: - Body
  var body: some View {
    Group {
      if #available(iOS 26.0, *) {
        modernTabView
      } else {
        legacyTabView
      }
    }
    .tint(asset.primaryColor)
    .safeAreaInset(edge: .bottom, spacing: 0) {
      if showMiniPlayer {
        miniPlayerBar
          .padding(.bottom, 50)
      }
    }
    .onChange(of: selectedTab) { _, newValue in
      if newValue == .lineup {
        audioPlayer.pause()
      }
    }
    .fullScreenCover(isPresented: $isPlayerExpanded) {
      if let song = audioPlayer.nowPlaying {
        PlaybackView(
          asset: asset,
          viewModel: ViewModelFactory.shared.createPlaybackViewModel(
            song: song,
            playerName: song.playerId.value,
            audioPlayer: audioPlayer
          )
        )
        .navigationTransition(.zoom(sourceID: "AUDIOPLAYER", in: animation))
        .ignoresSafeArea()
      }
    }
  }
}

extension MainTabView {

  @ViewBuilder
  private func tabContent(for tab: TabKey) -> some View {
    switch tab {
    case .lineup:
      AppCoordinatorContainer {
        LineupView(
          viewModel: lineupViewModel
        )
      }

    case .teamMembers:
      let asset = TeamMembersAssetVO(base: TeamAssetVO(team.id))
      AppCoordinatorContainer {
        TeamMembersView(
          team: team,
          asset: asset,
          viewModel: teamMembersViewModel
        )
      }

    case .search:
      AppCoordinatorContainer {
        SearchView(asset: SearchAssetVO(base: TeamAssetVO(TeamDataSource.toEntity(.samsung).id)))
      }
    }
  }

  @available(iOS 26.0, *)
  private var modernTabView: some View {
    TabView(selection: $selectedTab) {
      Tab("라인업", systemImage: "baseball.diamond.bases", value: .lineup) {
        tabContent(for: .lineup)
      }

      Tab("전체선수", systemImage: "person.2.fill", value: .teamMembers) {
        tabContent(for: .teamMembers)
      }

      Tab(value: .search, role: .search) {
        tabContent(for: .search)
      }
    }
    .tint(asset.secondaryColor)
  }

  private var legacyTabView: some View {
    TabView(selection: $selectedTab) {
      Tab("라인업", systemImage: "baseball.diamond.bases", value: .lineup) {
        tabContent(for: .lineup)
      }

      Tab("전체선수", systemImage: "person.2.fill", value: .teamMembers) {
        tabContent(for: .teamMembers)
      }

      Tab("검색", systemImage: "magnifyingglass", value: .search) {
        tabContent(for: .search)
      }
    }
    .tint(asset.secondaryColor)
  }

  @ViewBuilder
  private var miniPlayerBar: some View {
    if let song = audioPlayer.nowPlaying {
      MiniPlayerView(
        playerName: song.playerId.value,  // MARK: - PlayerInfo.name으로 교체 예정
        title: song.title,
        isPlaying: audioPlayer.isPlaying,
        onTap: {
          isPlayerExpanded.toggle()
        },
        onPlayPause: { audioPlayer.toggle() },
        onNext: { /* TODO: 다음 곡 */  }
      )
      .matchedTransitionSource(id: "AUDIOPLAYER", in: animation)
      .padding(.horizontal, 20)
      .padding(.vertical, 8)
    }
  }
}

#Preview {
  MainTabView(
    team: TeamDataSource.toEntity(.samsung),
    audioPlayer: DIContainer.shared.resolve(AudioPlaybackService.self)
  )
  .environment(AppCoordinator())
}
