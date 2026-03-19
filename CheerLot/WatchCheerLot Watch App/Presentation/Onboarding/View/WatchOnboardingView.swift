//
//  WatchOnboardingView.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/18/26.
//

import SwiftUI

struct WatchOnboardingView: View {
    var body: some View {
      ZStack {
        Rectangle()
          .fill(.ultraThinMaterial)
          .ignoresSafeArea()

          VStack(spacing: 2) {
              Text("직관 집중 ON")
                  .font(.SB7)
                  .foregroundStyle(.grayWhite)
              Text("방해금지 모드를 켜주세요")
                  .font(.M6)
                  .foregroundStyle(.gray200)
          }
      }
      .safeAreaInset(edge: .bottom) {
          if #available(watchOS 26.0, *) {
              Button("확인") {
                  print("Button was tapped!")
              }
              .glassEffect()
          } else {
              Button("확인") {
                  print("Button was tapped!")
              }
          }
      }
    }
}

#Preview {
    WatchOnboardingView()
}
