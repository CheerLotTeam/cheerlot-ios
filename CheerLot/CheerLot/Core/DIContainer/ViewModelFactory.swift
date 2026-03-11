//
//  ViewModelFactory.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

final class ViewModelFactory {

  static let shared = ViewModelFactory()

  private init() {}

  // MARK: - Onboarding
  func createTeamSelectViewModel() -> TeamSelectViewModel {
    TeamSelectViewModel()
  }

  // MARK: - Lineup
  func createLineupViewModel() -> LineupViewModel {
    LineupViewModel()
  }

  func createLineupChangeViewModel(_ lineupPlayer: LineupPlayerVO) -> LineupChangeViewModel {
    LineupChangeViewModel(lineupPlayer)
  }

  // MARK: - TeamMembers
  func createTeamMembersViewModel() -> TeamMembersViewModel {
    TeamMembersViewModel(
      audioPlayer: DIContainer.shared.resolve(AudioPlaybackService.self)
    )
  }

  // MARK: - Playback
  func createPlaybackViewModel(
    song: CheerSongInfo,
    playerName: String,
    audioPlayer: AudioPlaybackService
  ) -> PlaybackViewModel {
    PlaybackViewModel(song: song, playerName: playerName, audioPlayer: audioPlayer)
  }
}
