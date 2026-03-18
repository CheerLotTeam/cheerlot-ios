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
          Text("방해금지 모드를 켜주세요")
                .font(.M6)
            
            Button("Tap Me") { // The string is the button's text
                            // Code to execute when the button is tapped
                            print("Button was tapped!")
                        }
        }
      }
    }
}

#Preview {
    WatchOnboardingView()
}
