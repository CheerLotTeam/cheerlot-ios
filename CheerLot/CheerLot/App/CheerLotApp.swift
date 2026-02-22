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
    DIContainer.shared.assemble()
  }

  var body: some Scene {
    WindowGroup {
      //            RootViewSwitcher()
      AppCoordinatorContainer(
        team: TeamDataSource.toEntity(.kia),
        audioPlayer: DIContainer.shared.resolve(AudioPlaybackService.self))
    }
  }
}
