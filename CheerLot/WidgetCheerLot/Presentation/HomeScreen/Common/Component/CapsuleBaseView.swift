//
//  CapsuleBaseView.swift
//  CheerLot
//
//  Created by 이현주 on 4/5/26.
//

import SwiftUI
import WidgetKit

struct CapsuleBaseView: View {
  let title: String
  let bgColor: Color

  @Environment(\.widgetRenderingMode) var renderingMode

  var body: some View {
    HStack(spacing: 1) {
      Text(title)
        .font(.M6)

      Image(systemName: "baseball.diamond.bases")
        .font(.system(size: 9, weight: .regular))
    }
    .widgetAccentable()
    .foregroundStyle(.grayWhite)
    .padding(.horizontal, 9)
    .padding(.vertical, 5)
    .background(
      Capsule()
        .fill(renderingMode == .accented ? .white.opacity(0.25) : bgColor)
    )
  }
}

#Preview {
  CapsuleBaseView(title: "팀 설정하기", bgColor: .appPrimary)
}
