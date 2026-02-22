//
//  AppCoordinatorContainer.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

struct AppCoordinatorContainer: View {

  let team: TeamInfo
  let audioPlayer: AudioPlaybackService

  @State private var coordinator = AppCoordinator()

  var body: some View {
    NavigationStack(path: $coordinator.paths) {
      MainTabView(team: team, audioPlayer: audioPlayer)
        .navigationDestination(for: MainRoute.self) { route in
          coordinator.buildView(for: route)
        }
    }
    .environment(coordinator)
    .modal(item: $coordinator.modal) { route in
      coordinator.buildModalView(for: route, audioPlayer: audioPlayer)
    }
  }
}

// MARK: - Modal Modifier Extension
struct ModalModifier<Item: Identifiable, ModalContent: View>: ViewModifier {

  @Binding var item: Item?
  let content: (Item) -> ModalContent

  func body(content mainContent: Content) -> some View {
    if let item = item as? ModalRoute {
      switch item.presentationStyle {
      case .sheet:
        return AnyView(
          mainContent
            .sheet(item: $item) { route in
              self.content(route)
            }
        )
      case .fullScreen:
        return AnyView(
          mainContent
            .fullScreenCover(item: $item) { route in
              self.content(route)
            }
        )
      }
    } else {
      return AnyView(mainContent)
    }
  }
}
