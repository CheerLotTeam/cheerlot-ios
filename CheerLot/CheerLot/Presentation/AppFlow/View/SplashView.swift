//
//  SplashView.swift
//  CheerLot
//
//  Created by 이승진 on 7/10/25.
//

import Lottie
import SwiftUI

/// 앱 실행시 보여주는 스플래시 화면
struct SplashView: View {
  // TODO: - 분리 예정
  @EnvironmentObject private var remoteConfigChecker: RemoteConfigChecker
  let onAnimationComplete: () -> Void

  var body: some View {
    LottieView {
      try await DotLottieFile.named("cheerlot_splash")
    }
    .playing()
    .animationDidFinish { finished in
      if finished {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          onAnimationComplete()
        }
      }
    }
    .ignoresSafeArea()
    // foreground로 복귀할 때마다 checkVersion 함수를 실행
    .onReceive(
      NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    ) { _ in
      Task {
        await remoteConfigChecker.fetchRemoteConfig()
      }
    }
    .alert("최신 업데이트 안내", isPresented: $remoteConfigChecker.shouldForceUpdate) {
      Button("확인") {
        openAppStore()
      }
    } message: {
      Text("안정적인 서비스 사용을 위해\n최신 버전으로 업데이트해 주세요")
    }
    .alert("서비스 점검 안내", isPresented: $remoteConfigChecker.isServerChecking) {
      Button("확인") {
        exitApp()
      }
    } message: {
      Text(remoteConfigChecker.serverCheckingMessage)
    }
  }

  private func openAppStore() {
    if let url = URL(string: "itms-apps://itunes.apple.com/app/id6748527115") {
      UIApplication.shared.open(url)
    }
  }

  private func exitApp() {
    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      exit(0)
    }
  }
}
