//
//  ViewModelFactory.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

@MainActor
final class ViewModelFactory {

  static let shared = ViewModelFactory()

  private init() {}

  // MARK: - Onboarding
  func createTeamSelectViewModel(
    mode: TeamSelectMode,
    initialSelectedTeam: TeamID? = nil
  ) -> TeamSelectViewModel {
    TeamSelectViewModel(
      mode: mode,
      initialSelectedTeam: initialSelectedTeam
    )
  }

  // MARK: - Lineup
  func createLineupViewModel() -> LineupViewModel {
    LineupViewModel()
  }

  func createLineupChangeViewModel(_ lineupPlayer: LineupPlayerVO) -> LineupChangeViewModel {
    LineupChangeViewModel(lineupPlayer)
  }

  // MARK: - TeamMembers
  func createTeamMembersViewModel(team: TeamInfo, audioPlayer: AudioPlaybackService)
    -> TeamMembersViewModel
  {
    TeamMembersViewModel(audioPlayer: audioPlayer)
  }

  // MARK: - Playback
  func createPlaybackViewModel(
    song: CheerSongInfo,
    playerName: String,
    audioPlayer: AudioPlaybackService
  ) -> PlaybackViewModel {
    PlaybackViewModel(song: song, playerName: playerName, audioPlayer: audioPlayer)
  }
  
  // MARK: - Setting
  func createSettingViewModel(coordinator: AppCoordinator) -> SettingViewModel {
    SettingViewModel(coordinator: coordinator)
  }
}
