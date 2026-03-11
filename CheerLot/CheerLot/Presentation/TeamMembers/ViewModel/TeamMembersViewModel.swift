//
//  TeamMembersViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 2/20/26.
//

import Foundation
import Observation

@Observable
final class TeamMembersViewModel {
  
  // MARK: - State
  var members: [TeamMemberVO] = []
  var isLoading = false
  var errorMessage: String?
  
  private var currentTeamId: String?
  private var players: [PlayerInfo] = []
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase
  
  @ObservationIgnored
  @Injected(TeamPlayersSyncUseCase.self) private var teamPlayersSyncUseCase
  
  @ObservationIgnored
  private let audioPlayer: AudioPlaybackService
  
  // MARK: - Init
  
  init(audioPlayer: AudioPlaybackService) {
    self.audioPlayer = audioPlayer
  }
  
  // MARK: - Actions
  
  func onAppear() async {
    guard let teamInfo = teamSelectionUseCase.getCurrentTeam() else {
      errorMessage = "선택된 팀이 없습니다"
      return
    }
    
    currentTeamId = teamInfo.id.value
    
    await syncData()
    await loadData()
  }
  
  func refresh() async {
    await syncData()
    await loadData()
  }
  
  func didTapMember(_ member: TeamMemberVO) {
    guard let player = players.first(where: { $0.id == member.playerId }) else { return }
    guard let song = player.cheerSongs.first else { return }
    
    audioPlayer.play(song)
  }
  
  func didTapPlayAll() {
    let songs = players.flatMap(\.cheerSongs)
    guard let firstSong = songs.first else { return }
    audioPlayer.play(firstSong)
  }
  
  // MARK: - Private
  
  private func syncData() async {
    guard let currentTeamId else { return }

    do {
      try await teamPlayersSyncUseCase.syncIfNeeded(TeamID(currentTeamId))
    } catch {
      print("Team players sync failed: \(error)")
    }
  }
  
  private func loadData() async {
    guard let currentTeamId else { return }

    isLoading = true
    errorMessage = nil

    do {
      let playerEntities = try await teamPlayersSyncUseCase.getAllPlayers(TeamID(currentTeamId))
      print("playerEntities.count = \(playerEntities.count)")

      players = playerEntities

      members = playerEntities.map {
        TeamMemberVO(
          playerId: $0.id,
          name: $0.name,
          backNumber: $0.backNumber,
          hasSong: !$0.cheerSongs.isEmpty
        )
      }

      print("members.count = \(members.count)")
      isLoading = false
    } catch {
      isLoading = false
      errorMessage = "전체 선수 데이터를 불러올 수 없습니다: \(error.localizedDescription)"
    }
  }
  
//  private func loadData() async {
//    guard let currentTeamId else { return }
//    
//    isLoading = true
//    errorMessage = nil
//    
//    do {
//      let playerEntities = try await teamPlayersSyncUseCase.getAllPlayers(TeamID(currentTeamId))
//      players = playerEntities
//      
//      members = playerEntities.map {
//        TeamMemberVO(
//          playerId: $0.id,
//          name: $0.name,
//          backNumber: $0.backNumber,
//          hasSong: !$0.cheerSongs.isEmpty
//        )
//      }
//      
//      isLoading = false
//    } catch {
//      isLoading = false
//      errorMessage = "전체 선수 데이터를 불러올 수 없습니다: \(error.localizedDescription)"
//    }
//  }
}
