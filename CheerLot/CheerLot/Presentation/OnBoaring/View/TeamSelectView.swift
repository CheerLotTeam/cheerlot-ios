//
//  TeamSelectView.swift
//  CheerLot
//
//  Created by 이승진 on 6/10/25.
//

import SwiftUI

struct TeamSelectView: View {

  @State private var viewModel: TeamSelectViewModel

  let onClose: (() -> Void)?
  let onCompleteForChange: (() -> Void)?

  init(
    viewModel: TeamSelectViewModel,
    onClose: (() -> Void)? = nil,
    onCompleteForChange: (() -> Void)? = nil
  ) {
    _viewModel = State(initialValue: viewModel)
    self.onClose = onClose
    self.onCompleteForChange = onCompleteForChange
  }

  var body: some View {
    VStack(spacing: 15) {
      header
        .padding(.bottom, 10)

      teamListGrid

      if viewModel.mode.showsBottomButton {
        completeButton
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 30)
    .padding(.top, viewModel.mode == .change ? 20 : 32)
    .padding(.bottom, 12)
    .navigationTitle(viewModel.mode.navigationTitle)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if viewModel.mode.showsTopBar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            onClose?()
          } label: {
            Image(systemName: "xmark")
              .font(.system(size: 14, weight: .semibold))
          }
          .tint(.grayBlack)
        }

        ToolbarItem(placement: .principal) {
          Text(viewModel.mode.navigationTitle)
            .font(.SB6)
            .foregroundStyle(.grayBlack)
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button {
            viewModel.complete()
            onCompleteForChange?()
          } label: {
            Image(systemName: "checkmark")
              .font(.system(size: 14, weight: .semibold))
          }
          .tint(.grayBlack)
          .disabled(!viewModel.isButtonEnabled)
        }
      }
    }
  }
}

extension TeamSelectView {
  private var header: some View {
    Text(viewModel.mode.guideText)
      .font(viewModel.mode == .onboarding ? .SB4 : .M3)
      .foregroundStyle(viewModel.mode == .onboarding ? .grayBlack : .gray300)
  }

  private var teamListGrid: some View {
    GeometryReader { geometry in
      let rowCount = ceil(Double(viewModel.teams.count) / 2.0)
      let totalSpacing = max(0, 9 * (rowCount - 1))
      let cellHeight =
        rowCount > 0
        ? (geometry.size.height - totalSpacing) / rowCount
        : 0

      LazyVGrid(columns: viewModel.columns, spacing: 9) {
        ForEach(viewModel.teams) { team in
          TeamSelectCell(team: team, isSelected: viewModel.selectedTeamId == team.id) {
            viewModel.select(team.id)
          }
          .frame(height: cellHeight)
        }
      }
    }
  }

  private var completeButton: some View {
    Button {
      viewModel.complete()
    } label: {
      Text("완료")
        .font(.SB6)
        .foregroundStyle(viewModel.isButtonEnabled ? .grayWhite : .gray400)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(viewModel.isButtonEnabled ? .gray900 : .gray000)
        .clipShape(RoundedRectangle(cornerRadius: 35))
    }
    .disabled(!viewModel.isButtonEnabled)
  }
}

#Preview {
  TeamSelectView(viewModel: ViewModelFactory.shared.createTeamSelectViewModel(mode: .onboarding))
}
