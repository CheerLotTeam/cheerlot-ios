//
//  SettingView.swift
//  CheerLot
//
//  Created by 이승진 on 3/2/26.
//

import SwiftUI

/// 설정 화면 입니다.
struct SettingView: View {
  @Environment(AppCoordinator.self) private var coordinator

  // MARK: - Properties
  @State private var viewModel: SettingViewModel
  @State private var showInquirySafari: Bool = false

  private var currentTeam: TeamInfo {
    viewModel.currentTeam
  }

  private var asset: SettingAssetVO {
    SettingAssetVO(base: TeamAssetVO(currentTeam.id))
  }

  private var isTeamIconSelected: Bool {
    viewModel.appIconMode.isTeamSelected
  }

  private var supportMenus: [SupportInfoMenu] {
    SupportInfoMenu.allCases
  }

  // MARK: Init
  init(viewModel: SettingViewModel) {
    _viewModel = State(initialValue: viewModel)
  }

  // MARK: - Body
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        myTeamCard
        appIconContent
        supportContent
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
      .padding(.bottom, 24)
    }
    .hideMiniPlayerBar()
    .onAppear {
      viewModel.onAppear()
    }
    .navigationBar_backWithTitle(title: "설정") {
      coordinator.pop()
    }
    .toolbar(.hidden, for: .tabBar)
    .sheet(isPresented: $showInquirySafari) {
      if let url = URL(string: Constants.InquiryURL) {
        SafariView(url: url)
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: .teamSelected)) { _ in
      viewModel.didUpdateSelectedTeam()
    }
  }
}

// MARK: - Section
extension SettingView {
  /// 팀 바꾸기 버튼
  private var myTeamCard: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("나의 팀")
        .font(.SB8)
        .foregroundStyle(.gray500)

      TeamCardButton(
        action: {
          coordinator.presentModal(.teamChange(selectedTeamId: currentTeam.id.value))
        },
        asset: asset,
        team: currentTeam
      )
    }
  }

  /// 앱 아이콘 섹션
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
  }

  /// 지원 섹션
  private var supportContent: some View {
    VStack(alignment: .leading, spacing: 6) {
      sectionTitle("지원")

      SettingsMenuCard(
        titles: supportMenus.map(\.rawValue),
        onTap: { index in
          guard supportMenus.indices.contains(index) else { return }
          didTapSupportMenu(supportMenus[index])
        }
      )
    }
  }
}

// MARK: - Sub
extension SettingView {
  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(.SB8)
      .foregroundStyle(.gray500)
  }

  /// 앱 아이콘 선택 버튼 모음
  private var appIconButtonGroup: some View {
    HStack {
      Button {
        withAnimation(.easeInOut(duration: 0.2)) {
          viewModel.didSelectAppIconMode(.base)
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
          viewModel.didSelectAppIconMode(.team)
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
}

// MARK: - Actions
extension SettingView {
  private func didTapSupportMenu(_ menu: SupportInfoMenu) {
    switch menu {
    case .reportBug:
      showInquirySafari = true

    case .serviceIntro:
      coordinator.push(.serviceInfo)

    case .cheerlotTeam:
      coordinator.push(.makerInfo)
    }
  }
}
