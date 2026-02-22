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

    
    // MARK: - Playback
  // MARK: - TeamMembers
  func createTeamMembersViewModel(team: TeamInfo, audioPlayer: AudioPlaybackService) -> TeamMembersViewModel {
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
}
