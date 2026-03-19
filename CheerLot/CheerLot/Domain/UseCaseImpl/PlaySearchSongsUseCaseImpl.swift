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

  func play(result: SearchResultVO, coverImageName: String?) {
    guard !result.cheerSongs.isEmpty else { return }

    let songs = result.cheerSongs
    let playerNames = Array(repeating: result.playerName, count: songs.count)

    audioPlaybackUseCase.playQueue(
      songs,
      playerNames: playerNames,
      startAt: 0,
      coverImageName: coverImageName,
      mode: .search
    )
  }
}
