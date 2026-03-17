//
//  TeamSelectView.swift
//  CheerLot
//
//  Created by 이승진 on 6/10/25.
//

import SwiftUI

struct TeamSelectView: View {

  @State private var viewModel: TeamSelectViewModel

  init(viewModel: TeamSelectViewModel) {
    _viewModel = State(initialValue: viewModel)
  }

  var body: some View {
    VStack(spacing: 15) {
      header
        .padding(.bottom, 10)

      teamListGrid

      completeButton
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 30)
    .padding(.top, 32)
    .padding(.bottom, 12)
  }
}

extension TeamSelectView {
  private var header: some View {
    Text("응원 팀을 선택해주세요")
      .font(.SB4)
      .foregroundStyle(.grayBlack)
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
        .background(viewModel.isButtonEnabled ? .gray900 : .gray100)
        .clipShape(RoundedRectangle(cornerRadius: 35))
    }
    .disabled(!viewModel.isButtonEnabled)
  }
}

#Preview {
  TeamSelectView(viewModel: ViewModelFactory.shared.createTeamSelectViewModel())
}
