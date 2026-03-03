//
//  ServiceInfoView.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 서비스 소개 화면입니다.
struct ServiceInfoView: View {

  // MARK: - Body
  var body: some View {
    VStack(spacing: 20) {
      mainPageContent
      serviceContents

      Spacer()
    }
    .padding(.horizontal, 20)
    .navigationBar_backWithTitle(title: "서비스 소개") {
      // 네비게이션 연결
    }
  }
}

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
          serviceInfoTap(.mainPage)
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
          serviceInfoTap(policyMenus[index])
        }
      )
    }
  }
}

// MARK: - 이후 옮길 예정
extension ServiceInfoView {

  /// 서비스 약관
  private var policyMenus: [ServiceInfoMenu] {
    [.termsOfService, .privacyPolicy, .copyright]
  }

  /// 메뉴 탭 처리
  private func serviceInfoTap(_ menu: ServiceInfoMenu) {
    switch menu {
    case .mainPage:
      // coordinator.modal = .servicePage
      print("대표 페이지 열기")

    case .termsOfService:
      // coordinator.paths.append(.termsOfService)
      print("이용약관 화면으로 이동")

    case .privacyPolicy:
      // coordinator.paths.append(.privacyPolicy)
      print("개인정보처리방침 화면으로 이동")

    case .copyright:
      // coordinator.paths.append(.copyright)
      print("저작권 법적고지 화면으로 이동")
    }
  }
}

#Preview {
  ServiceInfoView()
}
