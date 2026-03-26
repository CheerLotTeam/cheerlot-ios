//
//  PlayLineupSongsUseCaseImpl.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

final class PlayLineupSongsUseCaseImpl: PlayLineupSongsUseCase {
  private let lineupAudioPlayer: LineupAudioPlayer

  init(lineupAudioPlayer: LineupAudioPlayer) {
    self.lineupAudioPlayer = lineupAudioPlayer
  }

  var isPlaying: Bool {
    lineupAudioPlayer.isPlaying
  }

  var currentTime: Double {
    lineupAudioPlayer.currentTime
  }

  var duration: Double {
    lineupAudioPlayer.duration
  }

  var currentIndex: Int {
    lineupAudioPlayer.currentIndex
  }

  func playQueue(
    _ songs: [CheerSongInfo],
    playerNames: [String],
    startAt index: Int,
    isGameDay: Bool
  ) {
    lineupAudioPlayer.playQueue(
      songs,
      playerNames: playerNames,
      startAt: index,
      isGameDay: isGameDay
    )
  }

  func play(at index: Int) {
    lineupAudioPlayer.play(at: index)
  }

  func playNext() {
    lineupAudioPlayer.playNext()
  }

  func playPrevious() {
    lineupAudioPlayer.playPrevious()
  }

  func pause() {
    lineupAudioPlayer.pause()
  }

  func resume() {
    lineupAudioPlayer.resume()
  }

  func toggle() {
    lineupAudioPlayer.toggle()
  }

  func stop() {
    lineupAudioPlayer.stop()
  }

  func seek(_ seconds: Double) {
    lineupAudioPlayer.seek(seconds)
  }

  func observeTime(
    every interval: Double,
    queue: DispatchQueue?,
    _ handler: @escaping (Double) -> Void
  ) -> Any {
    lineupAudioPlayer.observeTime(
      every: interval,
      queue: queue,
      handler
    )
  }

  func removeObserver(_ token: Any) {
    lineupAudioPlayer.removeObserver(token)
  }
}
