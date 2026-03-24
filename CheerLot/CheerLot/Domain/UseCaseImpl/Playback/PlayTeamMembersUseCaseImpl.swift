//
//  PlayTeamMembersUseCaseImpl.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

final class PlayTeamMembersUseCaseImpl: PlayTeamMembersUseCase {
  private let audioPlaybackUseCase: AudioPlaybackUseCase

  init(audioPlaybackUseCase: AudioPlaybackUseCase) {
    self.audioPlaybackUseCase = audioPlaybackUseCase
  }

  func playAll(
    rows: [TeamMembersSongVO],
    currentTeam: TeamInfo
  ) {
    let playableRows = rows.filter { $0.song != nil }
    guard !playableRows.isEmpty else { return }

    let songs = playableRows.compactMap(\.song)
    let playerNames = playableRows.map(\.playerName)
    let coverImageName = TeamAssetVO(currentTeam.id).coverImageName

    audioPlaybackUseCase.playQueue(
      songs,
      playerNames: playerNames,
      startAt: 0,
      coverImageName: coverImageName,
      mode: .normal
    )
  }

  func playSelected(
    row: TeamMembersSongVO,
    allRows: [TeamMembersSongVO],
    currentTeam: TeamInfo
  ) {
    let playableRows = allRows.filter { $0.song != nil }
    guard let startIndex = playableRows.firstIndex(where: { $0.id == row.id }) else { return }

    let songs = playableRows.compactMap(\.song)
    let playerNames = playableRows.map(\.playerName)
    let coverImageName = TeamAssetVO(currentTeam.id).coverImageName

    audioPlaybackUseCase.playQueue(
      songs,
      playerNames: playerNames,
      startAt: startIndex,
      coverImageName: coverImageName,
      mode: .normal
    )
  }
}
