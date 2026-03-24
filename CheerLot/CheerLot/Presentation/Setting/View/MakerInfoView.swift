//
//  MakerInfoView.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 쳐랏 팀 화면입니다.
struct MakerInfoView: View {
  @Environment(AppCoordinator.self) private var coordinator
  @Environment(\.openURL) private var openURL
  @Environment(MiniPlayerDisplayState.self) private var miniPlayerDisplayState

  // MARK: - Body
  var body: some View {
    VStack {
      SettingsMenuCard(
        titles: MakerInfoMenu.allCases.map(\.rawValue),
        onTap: { index in
          let menus = MakerInfoMenu.allCases
          guard menus.indices.contains(index) else { return }
          makerInfoTap(menus[index])
        }
      )

      Spacer()
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)

    .appBackground()
    .onAppear {
      miniPlayerDisplayState.hide()
    }
    .onDisappear {
      miniPlayerDisplayState.show()
    }
    .toolbar(.hidden, for: .tabBar)
    .navigationBar_backWithTitle(title: "쳐랏 팀") {
      coordinator.pop()
    }
  }
}

// MARK: - Actions
extension MakerInfoView {
  private func makerInfoTap(_ menu: MakerInfoMenu) {
    switch menu {
    case .instagram:
      guard let url = URL(string: Constants.instagramURL) else { return }
      openURL(url)

    case .goToReview:
      guard let url = URL(string: Constants.appStoreURL) else { return }
      openURL(url)
    }
  }
}

#Preview {
  MakerInfoView()
    .environment(AppCoordinator())
    .environment(MiniPlayerDisplayState())
}
