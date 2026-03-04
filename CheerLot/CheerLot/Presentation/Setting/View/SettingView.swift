//
//  SettingView.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 설정 화면 입니다.
struct SettingView: View {

  // MARK: - Properties
  let asset: SettingAssetVO
  let team: TeamInfo

  @State private var isTeamIconSelected: Bool = false

  // MARK: - Body
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        myTeamCard
        appIconContent
        supportContent
      }
      .padding(.horizontal, 20)
    }
    .navigationBar_backWithTitle(title: "설정") {}
  }
}

extension SettingView {
  /// 팀 바꾸기 버튼
  private var myTeamCard: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("나의 팀")
        .font(.SB8)
        .foregroundStyle(.gray500)

      TeamCardButton(
        action: {
          print("팀 카드 버튼입니다.")
        }, asset: asset, team: team)
    }
    .padding(.bottom, 20)
  }

  /// 앱 아이콘 설정
  private var appIconContent: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("앱 아이콘")
        .font(.SB8)
        .foregroundStyle(.gray500)

      appIconButtonGroup
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(.gray100)
        )
    }
    .padding(.bottom, 20)
  }

  /// 앱 아이콘 선택 버튼 모음
  private var appIconButtonGroup: some View {
    HStack {
      Button {
        withAnimation(.easeInOut(duration: 0.2)) {
          isTeamIconSelected = false
        }
      } label: {
        VStack(alignment: .center, spacing: 4) {
          Image(.baseAppIcon)
            .resizable()
            .scaledToFit()
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .saturation(isTeamIconSelected ? 0 : 1)
            .opacity(isTeamIconSelected ? 0.55 : 1)

          Text("기본")
            .font(.SB9)
            .foregroundStyle(isTeamIconSelected ? .gray300 : asset.primaryColor)
        }
      }
      .buttonStyle(.plain)

      Spacer()

      Button {
        withAnimation(.easeInOut(duration: 0.2)) {
          isTeamIconSelected = true
        }
      } label: {
        VStack(alignment: .center, spacing: 4) {
          ZStack {
            RoundedRectangle(cornerRadius: 14)
              .fill(isTeamIconSelected ? asset.primaryColor : .gray300)
              .frame(width: 64, height: 64)

            Image(.teamAppIcon)
              .resizable()
              .scaledToFit()
              .frame(width: 54, height: 44)
          }
          .frame(width: 64, height: 64)

          Text("팀")
            .font(.SB9)
            .foregroundStyle(isTeamIconSelected ? asset.primaryColor : .gray300)
        }
      }
      .buttonStyle(.plain)
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 60)
  }

  /// 지원 섹션
  private var supportContent: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("지원")
        .font(.SB8)
        .foregroundStyle(.gray500)

      SettingsMenuCard(
        titles: supportMenus.map(\.rawValue),
        onTap: { index in
          guard supportMenus.indices.contains(index) else { return }
          supportTap(supportMenus[index])
        }
      )
    }
  }
}

// MARK: - 이후 옮길 예정
extension SettingView {
  /// 지원 메뉴 목록 (enum)
  private var supportMenus: [SupportInfoMenu] {
    SupportInfoMenu.allCases
  }

  /// 지원 메뉴 탭 처리
  private func supportTap(_ menu: SupportInfoMenu) {
    switch menu {
    case .serviceIntro:
      // coordinator.paths.append(.serviceInfo)
      print("서비스 소개로 이동")

    case .cheerlotTeam:
      // coordinator.paths.append(.makerInfo)
      print("쳐랏 팀으로 이동")

    case .reportBug:
      // coordinator.modal = .inquiry
      print("문의하기 시트 열기")
    }
  }
}

#Preview {
  let team = TeamDataSource.toEntity(.samsung)
  let asset = SettingAssetVO(
    base: TeamAssetVO(team.id)
  )
  return SettingView(asset: asset, team: team)
}
