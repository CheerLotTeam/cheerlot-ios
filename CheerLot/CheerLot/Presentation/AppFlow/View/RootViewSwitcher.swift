//
//  RootViewSwitcher.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

struct RootViewSwitcher: View {

  @State private var appState: AppState = .splash
  @State private var isConfigCheckComplete = false
  @State private var isAnimationComplete = false
  @State private var audioPlayer: AudioPlaybackService = DIContainer.shared.resolve(
    AudioPlaybackService.self)
  @State private var teamSelectViewModel = ViewModelFactory.shared.createTeamSelectViewModel()
  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  // TODO: - 분리 예정
  @StateObject private var remoteConfigChecker = RemoteConfigChecker()

  var body: some View {
    content
      .environmentObject(remoteConfigChecker)
      .animation(.easeInOut(duration: 0.3), value: appState)
      .onReceive(NotificationCenter.default.publisher(for: .teamSelected)) { _ in
        transitionToMain()
      }
  }
}

extension RootViewSwitcher {
  @ViewBuilder
  private var content: some View {
    switch appState {
    case .splash:
      SplashView {
        handleAnimationComplete()
      }
      .task {
        await handleConfigCheck()
      }

    case .onboarding:
      TeamSelectView(viewModel: teamSelectViewModel)

    case .main(let team):
      MainTabView(team: team, audioPlayer: audioPlayer)
        .transition(.opacity)
        .id(team.id)
    }
  }

  private func handleConfigCheck() async {
    // Remote Config 체크
    await remoteConfigChecker.fetchRemoteConfig()

    // 서버 점검 또는 강제 업데이트 필요 시 리턴
    if remoteConfigChecker.isServerChecking || remoteConfigChecker.shouldForceUpdate {
      return
    }

    // Config 체크 완료
    isConfigCheckComplete = true

    // 애니메이션도 완료되었으면 화면 전환
    checkAndTransition()
  }

  private func handleAnimationComplete() {
    isAnimationComplete = true
    checkAndTransition()
  }

  @MainActor
  private func checkAndTransition() {
    guard isConfigCheckComplete && isAnimationComplete else { return }

    if teamSelectionUseCase.hasSelectedTeam() {
      transitionToMain()
    } else {
      appState = .onboarding
    }
  }

  @MainActor
  private func transitionToMain() {
    guard let team = teamSelectionUseCase.getCurrentTeam() else { return }
    appState = .main(team: team)
  }
}

#Preview {
  RootViewSwitcher()
}
