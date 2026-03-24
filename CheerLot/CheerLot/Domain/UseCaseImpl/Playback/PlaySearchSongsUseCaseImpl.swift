//
//  PlaySearchSongsUseCaseImpl.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

final class PlaySearchSongsUseCaseImpl: PlaySearchSongsUseCase {
  private let audioPlaybackUseCase: AudioPlaybackUseCase

  init(audioPlaybackUseCase: AudioPlaybackUseCase) {
    self.audioPlaybackUseCase = audioPlaybackUseCase
  }

  func play(
    selectedResult: SearchResultVO,
    allResults: [SearchResultVO],
    coverImageName: String?
  ) {
    let samePlayerRows = allResults.filter {
      $0.playerId == selectedResult.playerId && $0.song != nil
    }
    let songs = samePlayerRows.compactMap(\.song)

    guard !songs.isEmpty else { return }

    let playerNames = Array(repeating: selectedResult.playerName, count: songs.count)

    let startIndex = samePlayerRows.firstIndex { $0.id == selectedResult.id } ?? 0

    audioPlaybackUseCase.playQueue(
      songs,
      playerNames: playerNames,
      startAt: startIndex,
      coverImageName: coverImageName,
      mode: .search
    )
  }
}
