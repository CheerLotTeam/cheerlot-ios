//
//  PlaybackButtonStyle.swift
//  CheerLot
//
//  Created by 이승진 on 2/9/26.
//

import SwiftUI

/// 재생 화면에서 쓰이는 버튼 스타일
struct PlaybackButtonStyle: ButtonStyle {
  let size: CGFloat

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: size, height: size)
      .contentShape(Circle())
      .background {
        Circle()
          .fill(Color.white.opacity(configuration.isPressed ? 0.6 : 0))
      }
      .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
  }
}
