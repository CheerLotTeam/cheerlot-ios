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
    initialSelectedTeamId: String? = nil
  ) -> TeamSelectViewModel {
    TeamSelectViewModel(
      mode: mode,
      initialSelectedTeamId: initialSelectedTeamId
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
  func createTeamMembersViewModel(audioPlayer: AudioPlaybackService) -> TeamMembersViewModel {
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
  func createSettingViewModel() -> SettingViewModel {
    SettingViewModel()
  }
}
