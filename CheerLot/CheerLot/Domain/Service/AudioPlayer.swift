//
//  AudioPlayer.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

protocol AudioPlayer {
  var nowPlaying: CheerSongInfo? { get }
  var currentPlayerName: String? { get }
  var currentCoverImageName: String? { get }
  var isPlaying: Bool { get }
  var currentTime: Double { get }
  var duration: Double { get }
  var playbackMode: PlaybackMode { get }
  var canSkipManually: Bool { get }
  
  /// 현재 재생 큐에서 재생 중인 곡의 인덱스
  var currentQueueIndex: Int { get }

  func play(_ song: CheerSongInfo)
  func play(_ song: CheerSongInfo, playerName: String?, coverImageName: String?)
  func playQueue(_ songs: [CheerSongInfo], playerNames: [String], startAt index: Int, coverImageName: String?, mode: PlaybackMode)
  func playNext()
  func playPrevious()
  func pause()
  func resume()
  func toggle()
  func stop()
  func seek(_ seconds: Double)

  func observeTime(
    every interval: Double,
    queue: DispatchQueue?,
    _ handler: @escaping (Double) -> Void
  ) -> Any

  func removeObserver(_ token: Any)
}
