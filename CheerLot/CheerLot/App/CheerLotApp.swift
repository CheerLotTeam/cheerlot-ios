//
//  CheerLotApp.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import SwiftData
import SwiftUI

@main
struct CheerLotApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @State private var isBootstrapped = false
  @State private var showBootstrapError = false
  @State private var errorMessage = ""

  init() {
    DIContainer.shared.assemble()
  }

  var body: some Scene {
    WindowGroup {
      Group {
        if isBootstrapped {
          RootViewSwitcher()
        } else {
          Color(.grayWhite)
            .ignoresSafeArea()
        }
      }
      .task {
        await bootstrap()
      }
      .onOpenURL { url in
          guard url.scheme == "cheerlot",
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let from = components.queryItems?.first(where: { $0.name == "from" })?.value
          else { return }
          DIContainer.shared.resolve(AppLaunchContext.self).sourceWidgetKind = from
      }
      .alert("초기화 실패", isPresented: $showBootstrapError) {
        Button("다시 시도") {
          Task { await bootstrap() }
        }
      } message: {
        Text(errorMessage)
      }
    }
  }

  private func bootstrap() async {
    do {
      try await AppInitializer(
        modelContainer: LocalStorage.shared.modelContainer
      ).initialize()
      isBootstrapped = true
    } catch {
      errorMessage = "앱을 초기화하는 중 문제가 발생했습니다"
      showBootstrapError = true
    }
  }
}
