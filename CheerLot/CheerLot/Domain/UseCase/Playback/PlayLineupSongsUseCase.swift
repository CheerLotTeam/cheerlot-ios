//
//  PlayLineupSongsUseCase.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

protocol PlayLineupSongsUseCase {
  var isPlaying: Bool { get }
  var currentTime: Double { get }
  var duration: Double { get }
  var currentIndex: Int { get }

  func playQueue(
    _ songs: [CheerSongInfo],
    playerNames: [String],
    startAt index: Int,
    isGameDay: Bool
  )

  func play(at index: Int)
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
