//
//  LineupPlaybackService.swift
//  CheerLot
//
//  Created by 이승진 on 3/19/26.
//

import Foundation
import AVFoundation
import Combine

final class LineupPlaybackService: LineupAudioPlayer {

  // MARK: - Core
  private let player = AVPlayer()
  private var endOfTrackCancellable: AnyCancellable?

  // MARK: - Queue
  private var songs: [CheerSongInfo] = []
  private var playerNames: [String] = []
  private var currentSongIndex: Int = 0

  // MARK: - State
  private(set) var isPlaying: Bool = false

  var currentTime: Double {
    let s = player.currentTime().seconds
    return s.isFinite ? max(s, 0) : 0
  }

  var duration: Double {
    let s = player.currentItem?.duration.seconds ?? 0
    return s.isFinite ? max(s, 0) : 0
  }

  var currentIndex: Int {
    currentSongIndex
  }

  // MARK: - Playback
  func playQueue(
    _ songs: [CheerSongInfo],
    playerNames: [String],
    startAt index: Int
  ) {
    guard !songs.isEmpty else { return }
    guard songs.count == playerNames.count else { return }
    guard songs.indices.contains(index) else { return }

    self.songs = songs
    self.playerNames = playerNames
    self.currentSongIndex = index

    playCurrentSong()
  }

  func play(at index: Int) {
    guard songs.indices.contains(index) else { return }
    currentSongIndex = index
    playCurrentSong()
  }

  func playNext() {
    guard !songs.isEmpty else { return }

    if currentSongIndex + 1 < songs.count {
      currentSongIndex += 1
    } else {
      currentSongIndex = 0
    }

    playCurrentSong()
  }

  func playPrevious() {
    guard currentSongIndex - 1 >= 0 else { return }
    currentSongIndex -= 1
    playCurrentSong()
  }
  
  func pause() {
    player.pause()
    isPlaying = false
  }
  
  func resume() {
    guard player.currentItem != nil else { return }
    player.play()
    isPlaying = true
  }

  func toggle() {
    isPlaying ? pause() : resume()
  }

  func stop() {
    endOfTrackCancellable?.cancel()
    endOfTrackCancellable = nil

    player.pause()
    player.replaceCurrentItem(with: nil)

    songs = []
    playerNames = []
    currentSongIndex = 0
    isPlaying = false
  }

  func seek(_ seconds: Double) {
    let target = min(max(seconds, 0), duration)
    player.seek(to: CMTime(seconds: target, preferredTimescale: 600))
  }

  // MARK: - Observer
  func observeTime(
    every interval: Double = 0.5,
    queue: DispatchQueue? = .main,
    _ handler: @escaping (Double) -> Void
  ) -> Any {
    let cm = CMTime(seconds: interval, preferredTimescale: 600)
    return player.addPeriodicTimeObserver(forInterval: cm, queue: queue) { time in
      let seconds = time.seconds
      handler(seconds.isFinite ? seconds : 0)
    }
  }

  func removeObserver(_ token: Any) {
    player.removeTimeObserver(token)
  }
}

// MARK: - Private
private extension LineupPlaybackService {
  func playCurrentSong() {
    guard songs.indices.contains(currentSongIndex) else { return }

    let song = songs[currentSongIndex]

    if song.audioURL.hasPrefix("http"),
       let url = URL(string: song.audioURL) {
      play(url)
      return
    }

    playBundle(song.audioURL)
  }

  func play(_ url: URL) {
    endOfTrackCancellable?.cancel()
    endOfTrackCancellable = nil

    let item = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: item)
    player.play()
    isPlaying = true

    endOfTrackCancellable = NotificationCenter.default
      .publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.playNext()
      }
  }

  func playBundle(_ fileName: String) {
    let name = (fileName as NSString).deletingPathExtension
    let ext =
      (fileName as NSString).pathExtension.isEmpty ? "mp3" : (fileName as NSString).pathExtension

    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
      assertionFailure("번들에서 \(name).\(ext) 파일을 찾지 못했습니다.")
      isPlaying = false
      return
    }

    play(url)
  }
}
