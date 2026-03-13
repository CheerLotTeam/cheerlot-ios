//
//  RootViewSwitcher.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

struct RootViewSwitcher: View {

  @State private var appState: AppState = .splash
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
  }
}

extension RootViewSwitcher {
  @ViewBuilder
  private var content: some View {
    switch appState {
    case .splash:
      SplashView()
        .task {
          await handleSplash()
        }

    case .onboarding:
        TeamSelectView(viewModel: teamSelectViewModel)
            .onReceive(
                NotificationCenter.default.publisher(for: .teamSelected)
            ) { _ in
                transitionToMain()
            }
        
    case .main(let team):
        MainTabView(team: team, audioPlayer: audioPlayer)
            .transition(.opacity)
            .id(team.id)
            .onReceive(
                NotificationCenter.default.publisher(for: .teamSelected)
            ) { _ in
                // 팀 재선택 시
                transitionToMain()
            }
    }
  }

  private func handleSplash() async {
    // 1. Remote Config 체크
    await remoteConfigChecker.fetchRemoteConfig()

    // 2. 서버 점검 또는 강제 업데이트 필요 시 리턴
    if remoteConfigChecker.isServerChecking || remoteConfigChecker.shouldForceUpdate {
      return
    }

    // 3. 최소 스플래시 시간
    try? await Task.sleep(nanoseconds: 1_250_000_000)

    // 4. 팀 선택 여부 확인
    if teamSelectionUseCase.hasSelectedTeam() {
      if let team = teamSelectionUseCase.getCurrentTeam() {
        appState = .main(team: team)
      }
    } else {
      appState = .onboarding
    }
  }
    
    private func transitionToMain() {
        guard let team = teamSelectionUseCase.getCurrentTeam() else { return }
        appState = .main(team: team)
    }
}

#Preview {
  RootViewSwitcher()
}
