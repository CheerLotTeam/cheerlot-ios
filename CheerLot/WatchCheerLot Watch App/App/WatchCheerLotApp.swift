//
//  WatchCheerLotApp.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 6/2/25.
//

import SwiftUI

@main
struct WatchCheerLot_Watch_AppApp: App {

  @State private var lineupViewModel: LineupViewModel

  init() {
    DIContainer.shared.assemble()
    DIContainer.shared.resolve(WatchConnectivityRepository.self).activate()
    _lineupViewModel = State(initialValue: ViewModelFactory.shared.createLineupViewModel())
  }

  var body: some Scene {
    WindowGroup {
      LineupView(viewModel: lineupViewModel)
    }
  }
}
