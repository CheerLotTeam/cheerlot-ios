//
//  ServiceInfoView.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 서비스 소개 화면입니다.
struct ServiceInfoView: View {
  @Environment(AppCoordinator.self) private var coordinator
  @Environment(\.openURL) private var openURL
  @Environment(MiniPlayerDisplayState.self) private var miniPlayerDisplayState

  // MARK: - Properties
  private var policyMenus: [ServiceInfoMenu] {
    [.termsOfService, .privacyPolicy, .copyright]
  }

  // MARK: - Body
  var body: some View {
    VStack(spacing: 20) {
      mainPageContent
      serviceContents
      
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
    .navigationBar_backWithTitle(title: "서비스 소개") {
      coordinator.pop()
    }
  }
}

// MARK: - Section
extension ServiceInfoView {
  /// 대표 페이지
  private var mainPageContent: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("쳐랏 소개")
        .font(.SB8)
        .foregroundStyle(.gray500)

      SettingsMenuCard(
        titles: [ServiceInfoMenu.mainPage.rawValue],
        onTap: { _ in
          didTapServiceInfoMenu(.mainPage)
        }
      )
    }
  }

  /// 서비스 약관
  private var serviceContents: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("서비스 약관")
        .font(.SB8)
        .foregroundStyle(.gray500)

      SettingsMenuCard(
        titles: policyMenus.map(\.rawValue),
        onTap: { index in
          guard policyMenus.indices.contains(index) else { return }
          didTapServiceInfoMenu(policyMenus[index])
        }
      )
    }
  }
}

// MARK: - Actions
extension ServiceInfoView {
  private func didTapServiceInfoMenu(_ menu: ServiceInfoMenu) {
    switch menu {
    case .mainPage:
      guard let url = URL(string: Constants.mainPageURL) else { return }
      openURL(url)
    case .termsOfService:
      coordinator.push(.termsOfService)
    case .privacyPolicy:
      coordinator.push(.privacyPolicy)
    case .copyright:
      coordinator.push(.copyright)
    }
  }
}

#Preview {
  ServiceInfoView()
    .environment(AppCoordinator())
}
