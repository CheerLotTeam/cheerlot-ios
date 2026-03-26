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
  var duration: Double = 0

  var seekBarMaxValue: Double { max(duration, 1) }

  /// UI 표시용 메타 정보
  var title: String
  var playerName: String
  var lyrics: String
  var isSeeking: Bool = false

  // MARK: - Dependencies

  @ObservationIgnored
  @Injected(AudioPlaybackUseCase.self) private var audioPlaybackUseCase

  @ObservationIgnored
  @Injected(AnalyticsService.self) private var analyticsService

  @ObservationIgnored
  @Injected(TeamGameInfoUseCase.self) private var teamGameInfoUseCase

  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  private let source: PlaySource
  private var isGameDay = false

  /// 진행바 동기화용 observer 토큰
  private var timeObserver: Any?

  var canSkipManually: Bool {
    audioPlaybackUseCase.canSkipManually
  }

  // MARK: - Init

  init(song: CheerSongInfo, playerName: String, source: PlaySource) {
    self.title = song.title
    self.playerName = playerName
    self.lyrics = song.lyrics
    self.source = source

    syncFromService()
  }

  deinit {
    stopObservingTime()
  }

  // MARK: - Lifecycle

  func onAppear() async {
    await loadIsGameDay()
    syncFromService()
    startObservingTime()
    trackPresented()
  }

  func onDisappear() {
    trackDismissed()
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
    progress = max(seconds, 0)
    duration = max(audioPlaybackUseCase.duration, 1)

    audioPlaybackUseCase.seek(seconds)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
      guard let self else { return }
      self.isSeeking = false
      self.syncFromService()
    }
  }

  func playNext() {
    audioPlaybackUseCase.playNext()
    syncFromService()
  }

  func playPrevious() {
    audioPlaybackUseCase.playPrevious()
    syncFromService()
  }

  func closePlayback(completion: @escaping () -> Void) {
    audioPlaybackUseCase.resetToBeginning { [weak self] in
      guard let self else { return }
      self.progress = 0
      self.duration = max(self.audioPlaybackUseCase.duration, 1)
      self.syncFromService()
      completion()
    }
  }
}

// MARK: - Private Helpers

extension PlaybackViewModel {

  private func loadIsGameDay() async {
    guard let teamId = teamSelectionUseCase.getCurrentTeam()?.id else { return }
    isGameDay = await teamGameInfoUseCase.isGameDay(teamId)
  }

  /// 서비스 -> UI 상태 동기화
  fileprivate func syncFromService() {
    isPlaying = audioPlaybackUseCase.isPlaying

    let rawDuration = audioPlaybackUseCase.duration
    let rawCurrentTime = audioPlaybackUseCase.currentTime

    if rawDuration > 0 {
      duration = rawDuration
      if !isSeeking {
        progress = min(max(rawCurrentTime, 0), rawDuration)
      }
    } else {
      duration = 0
      if !isSeeking {
        progress = 0
      }
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

    timeObserver = audioPlaybackUseCase.observeTime(every: 0.1, queue: .main) { [weak self] _ in
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
    
    // MARK: - Analytics

    private func trackPresented() {
      let playerId = audioPlaybackUseCase.nowPlaying?.playerId.value ?? ""
      analyticsService.track(
        PlayViewPresentedEvent(
          source: source,
          viewType: .playback,
          isPlaying: isPlaying,
          isGameDay: isGameDay,
          playerId: playerId
        )
      )
    }

    private func trackDismissed() {
      let playerId = audioPlaybackUseCase.nowPlaying?.playerId.value ?? ""
      analyticsService.track(
        PlayViewDismissedEvent(
          source: source,
          viewType: .playback,
          isPlaying: isPlaying,
          isGameDay: isGameDay,
          playerId: playerId
        )
      )
    }
}
