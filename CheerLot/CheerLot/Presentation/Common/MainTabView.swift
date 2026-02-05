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

  let team: TeamInfo
  @State private var selectedTab: TabKey = .lineup

  private var asset: TeamAssetVO {
    TeamAssetVO(team: team)
  }

  private var showMiniPlayer: Bool {
    selectedTab != .lineup
  }

  init(team: TeamInfo) {
    self.team = team

    // TabBar 스타일 설정
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white.withAlphaComponent(0.75)

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }

  var body: some View {
    if #available(iOS 26.0, *) {
      modernTabView
    } else {
      // MARK: - 미니 플레이어바
      legacyTabView
    }
  }
}

extension MainTabView {
  private func tabContent(for tab: TabKey) -> some View {
    Group {
      switch tab {
      case .lineup:
        // MARK: - 해당 뷰로 교체
        Color.clear

      case .teamMembers:
        // MARK: - 해당 뷰로 교체
        Color.clear

      case .search:
        // MARK: - 해당 뷰로 교체
        Color.clear
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
    .tint(asset.primary)
    .tabBarMinimizeBehavior(.onScrollDown)
    .tabViewBottomAccessory {
      if showMiniPlayer {
        // MARK: - 미니 플레이어바
      }
    }
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
    .tint(asset.primary)
  }
}

#Preview {
  MainTabView(team: TeamDataSource.toEntity(.samsung))
}
