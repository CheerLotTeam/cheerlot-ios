//
//  MakerInfoView.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 쳐랏 팀 화면입니다.
struct MakerInfoView: View {

  // MARK: - Body
  var body: some View {
    VStack {
      SettingsMenuCard(
        titles: MakerInfoMenu.allCases.map(\.rawValue),
        onTap: { index in
          let menus = MakerInfoMenu.allCases
          guard menus.indices.contains(index) else { return }
          serviceInfoTap(menus[index])
        }
      )
      
      Spacer()
    }
    .padding(.horizontal, 20)
    .navigationBar_backWithTitle(title: "쳐랏 팀") {
      // 네비게이션 연결
    }
  }
}

// MARK: - 이후 옮길 예정
extension MakerInfoView {
  /// 메뉴 탭 처리
  private func serviceInfoTap(_ menu: MakerInfoMenu) {
    switch menu {
    case .instagram:
      // coordinator.modal = .servicePage
      print("인스타그램 이동")

    case .goToReview:
      // coordinator.paths.append(.termsOfService)
      print("앱스토어로 이동")
    }
  }
}

#Preview {
  MakerInfoView()
}
