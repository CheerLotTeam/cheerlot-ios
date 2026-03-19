//
//  MainRoute.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

enum MainRoute: Hashable {
  case settings

  // 지원
  case serviceInfo
  case makerInfo

  // 서비스 소개
  case termsOfService
  case privacyPolicy
  case copyright
}

extension AppCoordinator {

  @ViewBuilder
  func buildView(for route: MainRoute) -> some View {
    let factory = ViewModelFactory.shared

    // TODO: - View 넣기
    switch route {
    case .settings:
      let viewModel = factory.createSettingViewModel()
      SettingView(viewModel: viewModel)

    case .serviceInfo:
      ServiceInfoView()

    case .makerInfo:
      MakerInfoView()

    case .termsOfService:
      ServiceAppInfoView(
        title: "이용약관",
        text: Constants.AppInfo.termsOfService
      )

    case .privacyPolicy:
      ServiceAppInfoView(
        title: "개인정보처리방침",
        text: Constants.AppInfo.privacyPolicy
      )

    case .copyright:
      ServiceAppInfoView(
        title: "저작권 법적고지",
        text: Constants.AppInfo.copyrightPolicy
      )
    }
  }
}
