//
//  SearchView.swift
//  CheerLot
//
//  Created by 이승진 on 2/28/26.
//

import SwiftUI

/// 팀 내 선수를 검색할 수 있는 화면입니다.
struct SearchView: View {
  @Environment(AppCoordinator.self) private var coordinator

  let asset: SearchAssetVO
  @State private var viewModel: SearchViewModel
  @State private var isSearchPresented = false

  init(asset: SearchAssetVO, viewModel: SearchViewModel) {
    self.asset = asset
    _viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    content
      .toolBar_largeTitle(title: "검색")
      .appBackground()
      .searchable(
        text: Binding(
          get: { viewModel.query },
          set: { viewModel.updateQuery($0) }
        ),
        isPresented: $isSearchPresented,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "검색어를 입력해주세요"
      )
      .task {
        await viewModel.onAppear()
        isSearchPresented = true
      }
      .onReceive(NotificationCenter.default.publisher(for: .teamSelected)) { notification in
        guard let team = notification.object as? TeamInfo else { return }
        Task {
          await viewModel.didUpdateSelectedTeam(team)
        }
      }
      .toastMessage(
        isPresented: $viewModel.showToast,
        message: viewModel.toastMessage
      )
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else if viewModel.isQueryEmpty {
      memberSearchView
    } else if viewModel.results.isEmpty {
      emptySearchView
    } else {
      searchResultView(results: viewModel.results)
    }
  }

  private var memberSearchView: some View {
    VStack(alignment: .center, spacing: 28) {
      Image(.noGame)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 130)

      Text("우리 팀 선수를 검색해보세요")
        .font(.M1)
        .foregroundStyle(.gray200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private var emptySearchView: some View {
    VStack(alignment: .center, spacing: 28) {
      Image(.noSeason)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 130)

      Text("검색 결과가 없습니다")
        .font(.M1)
        .foregroundStyle(.gray200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  private func searchResultView(results: [SearchResultVO]) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("총 \(results.count)곡")
        .font(.M4)
        .foregroundStyle(.gray400)
        .padding(.leading, 20)
        .padding(.top, 16)

      List(results) { result in
        SearchResultCell(
          asset: asset,
          memberName: result.playerName,
          hasSong: result.hasSong,
          title: result.titleText,
          backNumber: result.backNumber
        )
        .contentShape(Rectangle())
        .onTapGesture {
          guard let song = result.song else {
            viewModel.showNoSongToast()
            return
          }

          viewModel.didTapResult(result)

          coordinator.presentModal(
            .basePlayback(
              teamId: viewModel.currentTeam.id,
              song: song,
              playerName: result.playerName
            )
          )
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
      }
      .listStyle(.plain)
      .scrollDismissesKeyboard(.immediately)
    }
  }
}
