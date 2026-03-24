//
//  LineupChangeSheetView.swift
//  CheerLot
//
//  Created by 이현주 on 2/22/26.
//

import SwiftUI

struct LineupChangeSheetView: View {
  @State private var viewModel: LineupChangeViewModel
  @Environment(AppCoordinator.self) private var coordinator
  let onComplete: () -> Void

  init(viewModel: LineupChangeViewModel, onComplete: @escaping () -> Void) {
    _viewModel = State(initialValue: viewModel)
    self.onComplete = onComplete
  }

  var body: some View {
    VStack(spacing: 18) {
      header
        .padding(.top, 10)

      if let asset = viewModel.asset {
        playerListGrid(asset: asset)
      } else {
        Color.clear
      }
    }
    .appBackground()
    .toolBar_editMode(
      title: "선수 교체",
      checkColor: viewModel.selectedPlayer != nil
        ? (viewModel.asset?.primaryColor ?? .gray800) : .gray800
    ) {
      coordinator.dismissModal()
    } onCheck: {
      Task {
        let success = await viewModel.swapPlayers()
        if success {
          onComplete()
          coordinator.dismissModal()
        }
      }
    }
    .disabled(viewModel.isSwapping)
    .overlay {
      if viewModel.isLoading || viewModel.isSwapping {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .appBackground()
      }
    }
    .task {
      await viewModel.onAppear()
    }
    .errorAlert(errorMessage: $viewModel.errorMessage)
    .toastMessage(
      isPresented: $viewModel.showToast,
      message: viewModel.toastMessage,
      showCaution: false
    )
  }
}

extension LineupChangeSheetView {
  private var header: some View {
    VStack(spacing: 0) {
      Text("교체 선수")
        .font(.M3)
        .foregroundStyle(.gray300)

      Text(viewModel.lineupPlayer.name)
        .font(.B3)
        .foregroundStyle(.grayBlack)
    }
  }

  private func playerListGrid(asset: LineupChangeAssetVO) -> some View {
    ScrollView {
      LazyVGrid(columns: viewModel.columns, spacing: 20) {
        ForEach(viewModel.benchPlayers) { player in
          ChangePlayerSelectCell(
            player: player,
            asset: asset,
            isSelected: viewModel.isSelected(player),
            action: {
              viewModel.selectPlayer(player)
            }
          )
          .frame(height: 60)
        }
      }
      .padding(EdgeInsets(top: 18, leading: 20, bottom: 18, trailing: 20))
    }
    .scrollIndicators(.hidden)
  }
}
