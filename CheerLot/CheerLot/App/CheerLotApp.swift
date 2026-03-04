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

  init() {
    Task {
      let initializer = AppInitializer(modelContainer: LocalStorage.shared.modelContainer)
      await initializer.initialize()
    }

    DIContainer.shared.assemble()
  }

  var body: some Scene {
    WindowGroup {
      RootViewSwitcher()
    }
  }
}
