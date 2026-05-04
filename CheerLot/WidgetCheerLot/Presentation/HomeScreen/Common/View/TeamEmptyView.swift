//
//  TeamEmptyView.swift
//  CheerLot
//
//  Created by 이현주 on 4/5/26.
//

import SwiftUI
import WidgetKit

struct TeamEmptyView: View {
  let isSmallSize: Bool
  @Environment(\.widgetRenderingMode) var renderingMode

  var body: some View {
    ZStack {
        if renderingMode != .accented {
            LinearGradient(
                colors: [
                    .grayWhite,
                    .appPrimary,
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .opacity(0.2)
        }

      contentsView
    }
  }
}

extension TeamEmptyView {
  private var textView: some View {
    VStack(spacing: 2) {
      Text("팀 정보 없음")
        .font(isSmallSize ? .SB5 : .SB3)
        .foregroundStyle(Color.appPrimary)
        .widgetAccentable()

      if !isSmallSize {
        Text("앱에서 팀을 선택해주세요")
          .font(.M5)
          .foregroundStyle(.gray400)
          .widgetAccentable()
      }
    }
  }

  private var contentsView: some View {
    VStack(spacing: 0) {
      Spacer()
      Spacer()
      textView
      Spacer()
      CapsuleBaseView(
        title: "팀 설정하기",
        bgColor: .appPrimary
      )
      Spacer()
    }
  }
}

#Preview {
  TeamEmptyView(isSmallSize: false)
}
