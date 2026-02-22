//
//  LineupCellActionsModifier.swift
//  CheerLot
//
//  Created by 이현주 on 2/19/26.
//

import SwiftUI

struct LineupCellActionsModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .swipeActions(edge: .trailing) {
        Button {
          // TODO: - sheet 띄우기
        } label: {
          Label("교체", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
        }
        .tint(.change)
      }
      .contextMenu {
        Button {
          // TODO: - sheet 띄우기
        } label: {
          Label("교체", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
        }
        // TODO: - 응원가 갯수 따라 ForEach로 버튼 생성
      }
  }
}
