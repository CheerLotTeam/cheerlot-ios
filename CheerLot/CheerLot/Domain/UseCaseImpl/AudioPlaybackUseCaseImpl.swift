//
//  AudioPlaybackUseCaseImpl.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

final class AudioPlaybackUseCaseImpl: AudioPlaybackUseCase {
  private let audioPlayer: AudioPlayer

  init(audioPlayer: AudioPlayer) {
    self.audioPlayer = audioPlayer
  }

  var nowPlaying: CheerSongInfo? {
    audioPlayer.nowPlaying
  }

  var currentPlayerName: String? {
    audioPlayer.currentPlayerName
  }

  var currentCoverImageName: String? {
    audioPlayer.currentCoverImageName
  }

  var isPlaying: Bool {
    audioPlayer.isPlaying
  }

  var currentTime: Double {
    audioPlayer.currentTime
  }
  
  var currentQueueIndex: Int {
    audioPlayer.currentQueueIndex
  }
  
  var playbackMode: PlaybackMode {
    audioPlayer.playbackMode
  }
  
  var canSkipManually: Bool {
    audioPlayer.canSkipManually
  }

  var duration: Double {
    audioPlayer.duration
  }

  func play(_ song: CheerSongInfo) {
    audioPlayer.play(song)
  }

  func play(
    _ song: CheerSongInfo,
    playerName: String?,
    coverImageName: String?
  ) {
    audioPlayer.play(
      song,
      playerName: playerName,
      coverImageName: coverImageName
    )
  }

  func playQueue(
    _ songs: [CheerSongInfo],
    playerNames: [String],
    startAt index: Int,
    coverImageName: String?,
    mode: PlaybackMode = .normal
  ) {
    audioPlayer.playQueue(
      songs,
      playerNames: playerNames,
      startAt: index,
      coverImageName: coverImageName,
      mode: mode
    )
  }

  func playNext() {
    audioPlayer.playNext()
  }

  func playPrevious() {
    audioPlayer.playPrevious()
  }

  func pause() {
    audioPlayer.pause()
  }

  func resume() {
    audioPlayer.resume()
  }

  func toggle() {
    audioPlayer.toggle()
  }

  func stop() {
    audioPlayer.stop()
  }

  func seek(_ seconds: Double) {
    audioPlayer.seek(seconds)
  }

  func observeTime(
    every interval: Double,
    queue: DispatchQueue?,
    _ handler: @escaping (Double) -> Void
  ) -> Any {
    audioPlayer.observeTime(
      every: interval,
      queue: queue,
      handler
    )
  }

  func removeObserver(_ token: Any) {
    audioPlayer.removeObserver(token)
  }
}
