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
  
  func createLineupPlaybackViewModel(
    players: [LineupPlayerVO],
    startIndex: Int
  ) -> LineupPlaybackViewModel {
    LineupPlaybackViewModel(
      players: players,
      startIndex: startIndex
    )
  }
  
  // MARK: - TeamMembers
  func createTeamMembersViewModel() -> TeamMembersViewModel {
    TeamMembersViewModel()
  }
  
  // MARK: - Playback
  func createPlaybackViewModel(
    song: CheerSongInfo,
    playerName: String
  ) -> PlaybackViewModel {
    PlaybackViewModel(
      song: song,
      playerName: playerName
    )
  }
  
  // MARK: - Search
  func createSearchViewModel() -> SearchViewModel {
    SearchViewModel()
  }
  
  // MARK: - Setting
  func createSettingViewModel() -> SettingViewModel {
    SettingViewModel()
  }
}
