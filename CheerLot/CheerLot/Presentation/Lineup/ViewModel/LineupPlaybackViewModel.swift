//
//  LineupPlaybackViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation
import Observation

@Observable
final class LineupPlaybackViewModel {
  let players: [LineupPlayerVO]
  let startIndex: Int

  var currentPlaybackIndex: Int
  var isSyncingFromPlayback = false
  var isPlaying = false

  @ObservationIgnored
  @Injected(PlayLineupSongsUseCase.self) private var playLineupSongsUseCase

  private var timeObserver: Any?

  init(
    players: [LineupPlayerVO],
    startIndex: Int
  ) {
    self.players = players
    self.startIndex = startIndex
    self.currentPlaybackIndex = startIndex
  }

  deinit {
    stopObservingPlayback()
  }

  func onAppear() {
    let flattenedItems = players.flatMap { player in
      player.cheerSongs.map { song in
        (playerName: player.name, song: song.toEntity())
      }
    }
    
    guard !flattenedItems.isEmpty else { return }
    
    if playLineupSongsUseCase.duration > 0 {
      playLineupSongsUseCase.resume()
      isPlaying = playLineupSongsUseCase.isPlaying
      startObservingPlayback()
      return
    }
    
    guard flattenedItems.indices.contains(startIndex) else { return }
    
    let songs = flattenedItems.map(\.song)
    let playerNames = flattenedItems.map(\.playerName)
    
    playLineupSongsUseCase.playQueue(
      songs,
      playerNames: playerNames,
      startAt: startIndex
    )
    
    currentPlaybackIndex = startIndex
    isPlaying = playLineupSongsUseCase.isPlaying
    startObservingPlayback()
  }
  
  func pausePlayback() {
    playLineupSongsUseCase.pause()
    isPlaying = false
  }

  func stopPlayback() {
    stopObservingPlayback()
    playLineupSongsUseCase.stop()
    isPlaying = false
  }
  
  func onDisappear() {
    stopPlayback()
  }

  func togglePlayback() {
    playLineupSongsUseCase.toggle()
    isPlaying = playLineupSongsUseCase.isPlaying
  }

  func didScrollToCard(at index: Int) {
    guard !isSyncingFromPlayback else { return }
    guard index != playLineupSongsUseCase.currentIndex else { return }

    playLineupSongsUseCase.play(at: index)
    currentPlaybackIndex = index
    isPlaying = playLineupSongsUseCase.isPlaying
  }

  private func startObservingPlayback() {
    guard timeObserver == nil else { return }

    timeObserver = playLineupSongsUseCase.observeTime(every: 0.5, queue: .main) { [weak self] _ in
      guard let self else { return }

      let queueIndex = self.playLineupSongsUseCase.currentIndex
      guard queueIndex != self.currentPlaybackIndex else { return }

      self.isSyncingFromPlayback = true
      self.currentPlaybackIndex = queueIndex

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        self.isSyncingFromPlayback = false
      }
    }
  }
  
  private func stopObservingPlayback() {
    if let token = timeObserver {
      playLineupSongsUseCase.removeObserver(token)
      timeObserver = nil
    }
  }
}
