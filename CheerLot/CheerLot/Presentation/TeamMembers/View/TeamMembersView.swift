//
//  TeamMembersView.swift
//  CheerLot
//
//  Created by 이승진 on 2/2/26.
//

import SwiftUI

/// 전체 선수 화면입니다.
struct TeamMembersView: View {
  @Environment(AppCoordinator.self) private var coordinator

  // MARK: - Properties
  @State private var viewModel: TeamMembersViewModel

  private var asset: TeamMembersAssetVO {
    TeamMembersAssetVO(base: TeamAssetVO(team.id))
  }

  private var team: TeamInfo {
    viewModel.currentTeam
  }

  // MARK: - Init
  init(viewModel: TeamMembersViewModel) {
    _viewModel = State(initialValue: viewModel)
  }

  // MARK: - Body
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        header
        contents
      }
      .padding(.horizontal, 20)
    }
    .toolBar_titleWithProfile(title: "전체 선수") {
      coordinator.push(.settings)
    }
    .task {
      await viewModel.onAppear()
    }
    .refreshable {
      await viewModel.refresh()
    }
    .onReceive(NotificationCenter.default.publisher(for: .teamSelected)) { notification in
      guard let team = notification.object as? TeamInfo else { return }
      Task {
        await viewModel.didUpdateSelectedTeam(team)
      }
    }
  }
}

extension TeamMembersView {
  /// 상단 헤더 영역 (TeamCard + infoPlayRow)
  private var header: some View {
    VStack(alignment: .center, spacing: 12) {
      TeamCard(asset: asset, team: team)
      infoPlayRow
    }
  }

  /// 곡 수 + 전체 재생 버튼
  private var infoPlayRow: some View {
    HStack {
      Text("총 \(viewModel.totalSongCount)곡")
        .font(.M4)
        .foregroundStyle(.gray400)

      Spacer()

      PlayButton(
        action: { viewModel.didTapPlayAll() },
        asset: asset
      )
    }
    .padding(.leading, 10)
  }

  /// 상태별 컨텐츠 영역
  @ViewBuilder
  private var contents: some View {
    if viewModel.isLoading && viewModel.rows.isEmpty {
      loadingView
    } else if let errorMessage = viewModel.errorMessage, viewModel.rows.isEmpty {
      errorView(message: errorMessage)
    } else {
      memberListView
    }
  }

  private var loadingView: some View {
    ProgressView()
      .padding(.top, 40)
  }

  private func errorView(message: String) -> some View {
    Text(message)
      .font(.M4)
      .foregroundStyle(.gray400)
      .padding(.top, 40)
  }

  /// 선수 목록 뷰
  private var memberListView: some View {
    ForEach(viewModel.rows) { item in
      TeamMembersCell(
        asset: asset,
        memberName: item.playerName,
        hasSong: item.hasSong,
        title: item.titleText,
        backNumber: item.backNumber,
      )
      .contentShape(Rectangle())
      .onTapGesture {
        viewModel.didTapSong(item)
      }
    }
  }
}
