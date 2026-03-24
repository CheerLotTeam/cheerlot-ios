//
//  PlaybackViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 2/11/26.
//

import Foundation
import Observation

@Observable
final class PlaybackViewModel {

  // MARK: - UI State

  /// 재생/일시정지 상태
  var isPlaying: Bool = false

  /// 현재 재생 위치(초)
  var progress: Double = 0

  /// 총 길이(초)
  var duration: Double = 1

  /// UI 표시용 메타 정보
  var title: String
  var playerName: String
  var lyrics: String

  // MARK: - Dependencies
  @ObservationIgnored
  @Injected(AudioPlaybackUseCase.self) private var audioPlaybackUseCase

  /// 진행바 동기화용 observer 토큰
  private var timeObserver: Any?

  var canSkipManually: Bool {
    audioPlaybackUseCase.canSkipManually
  }

  // MARK: - Init

  init(song: CheerSongInfo, playerName: String) {
    self.title = song.title
    self.playerName = playerName
    self.lyrics = song.lyrics

    // 최초 진입
    syncFromService()
  }

  deinit {
    stopObservingTime()
  }

  // MARK: - Lifecycle

  /// 화면이 나타날 때: 현재 상태 동기화 + tick 시작
  func onAppear() {
    syncFromService()
    startObservingTime()
  }

  /// 화면이 사라질 때: tick 해제
  func onDisappear() {
    stopObservingTime()
  }

  // MARK: - User Actions

  /// 재생/일시정지 토글
  func togglePlayback() {
    audioPlaybackUseCase.toggle()
    syncFromService()
  }

  /// 특정 초로 이동
  func seek(to seconds: Double) {
    audioPlaybackUseCase.seek(seconds)

    // 실제 currentTime은 다음 tick에서 다시 서비스 값으로 싱크됨
    progress = max(seconds, 0)
    duration = max(audioPlaybackUseCase.duration, 1)
  }

  func playNext() {
    audioPlaybackUseCase.playNext()
    syncFromService()
  }

  func playPrevious() {
    audioPlaybackUseCase.playPrevious()
    syncFromService()
  }
}

// MARK: - Private Helpers

extension PlaybackViewModel {

  /// 서비스 -> UI 상태 동기화
  fileprivate func syncFromService() {
    isPlaying = audioPlaybackUseCase.isPlaying

    let rawDuration = audioPlaybackUseCase.duration
    let rawCurrentTime = audioPlaybackUseCase.currentTime

    if rawDuration > 0 {
      duration = rawDuration
      progress = min(max(rawCurrentTime, 0), rawDuration)
    } else {
      duration = 1
      progress = 0
    }

    if let song = audioPlaybackUseCase.nowPlaying {
      title = song.title
      lyrics = song.lyrics
      playerName = audioPlaybackUseCase.currentPlayerName ?? song.playerId.value
    }
  }

  /// 진행 상태를 주기적으로 업데이트
  fileprivate func startObservingTime() {
    guard timeObserver == nil else { return }

    timeObserver = audioPlaybackUseCase.observeTime(every: 0.5, queue: .main) { [weak self] _ in
      guard let self else { return }
      self.syncFromService()
    }
  }

  /// observer 해제
  fileprivate func stopObservingTime() {
    if let token = timeObserver {
      audioPlaybackUseCase.removeObserver(token)
      timeObserver = nil
    }
  }
}
