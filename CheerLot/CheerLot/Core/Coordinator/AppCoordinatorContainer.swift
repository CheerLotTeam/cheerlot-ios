//
//  AppCoordinatorContainer.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

struct AppCoordinatorContainer<Content: View>: View {

  let content: () -> Content

  @State private var coordinator = AppCoordinator()

  var body: some View {
    NavigationStack(path: $coordinator.paths) {
      content()
        .navigationDestination(for: MainRoute.self) { route in
          coordinator.buildView(for: route)
        }
    }
    .environment(coordinator)
    .sheet(item: $coordinator.presentedSheet) { route in
        coordinator.buildModalView(for: route)
            .environment(coordinator)
    }
    .fullScreenCover(item: $coordinator.presentedFullScreen) { route in
        coordinator.buildModalView(for: route)
            .environment(coordinator)
    }
  }
}
