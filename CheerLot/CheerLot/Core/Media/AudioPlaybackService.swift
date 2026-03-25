//
//  AudioPlaybackService.swift
//  CheerLot
//
//  Created by 이승진 on 2/20/26.
//

import AVFoundation
import Combine
import MediaPlayer
import Observation
import UIKit

/// 앱 전역 오디오 재생을 담당하는 서비스
@Observable
final class AudioPlaybackService: AudioPlayer {

  // MARK: - Core
  private let player = AVPlayer()
  private let nowPlayingSession: MPNowPlayingSession
  private var endOfTrackCancellable: AnyCancellable?
  private var sessionActive = false

  // LockScreen NowPlayingInfo 주기 갱신용
  private var nowPlayingTick: Any?

  // RemoteCommand 중복 등록 방지
  private var remoteConfigured = false

  // MARK: - Queue
  private var queue: [CheerSongInfo] = []
  private var queuePlayerNames: [String] = []
  private var currentIndex: Int = 0

  // MARK: - State (UI Binding)
  var nowPlaying: CheerSongInfo?
  var currentPlayerName: String?
  var currentCoverImageName: String?
  var isPlaying: Bool = false
  var playbackMode: PlaybackMode = .normal

  var currentQueueIndex: Int {
    currentIndex
  }

  var canSkipManually: Bool {
    playbackMode == .normal && queue.count > 1
  }

  // MARK: - Init
  init() {
    self.nowPlayingSession = MPNowPlayingSession(players: [player])
    setupSession()
    setupRemoteCommands()
    startNowPlayingTick()
  }

  deinit {
    stopNowPlayingTick()
  }

  // MARK: - Playback
  func play(_ song: CheerSongInfo) {
    play(song, playerName: nil, coverImageName: nil)
  }

  func play(_ song: CheerSongInfo, playerName: String?, coverImageName: String?) {
    queue = [song]
    queuePlayerNames = [playerName ?? song.playerId.value]
    currentIndex = 0
    playbackMode = .normal

    nowPlaying = song

    currentPlayerName = playerName ?? song.playerId.value
    currentCoverImageName = coverImageName

    playCurrentSong()
  }

  /// 재생큐
  func playQueue(
    _ songs: [CheerSongInfo],
    playerNames: [String],
    startAt index: Int = 0,
    coverImageName: String?,
    mode: PlaybackMode = .normal
  ) {
    guard !songs.isEmpty else { return }
    guard songs.count == playerNames.count else { return }
    guard songs.indices.contains(index) else { return }

    queue = songs
    queuePlayerNames = playerNames
    currentIndex = index
    playbackMode = mode

    nowPlaying = queue[currentIndex]
    currentPlayerName = queuePlayerNames[currentIndex]
    currentCoverImageName = coverImageName

    playCurrentSong()
  }

  /// 다음곡
  func playNext() {
    guard canSkipManually else { return }
    guard !queue.isEmpty else { return }

    currentIndex = (currentIndex + 1) % queue.count
    nowPlaying = queue[currentIndex]
    currentPlayerName = queuePlayerNames[currentIndex]

    playCurrentSong()
  }

  /// 이전곡
  func playPrevious() {
    guard canSkipManually else { return }
    guard !queue.isEmpty else { return }

    if currentTime > 3 {
      seek(0)
      return
    }

    currentIndex = (currentIndex - 1 + queue.count) % queue.count
    nowPlaying = queue[currentIndex]
    currentPlayerName = queuePlayerNames[currentIndex]

    playCurrentSong()
  }

  private func playCurrentSong() {
    guard let song = nowPlaying else { return }

    if song.audioURL.hasPrefix("http"),
      let url = URL(string: song.audioURL)
    {
      play(url)
      return
    }

    playBundle(song.audioURL)
  }

  /// 실제 교체 & 재생
  func play(_ url: URL) {
    // 이전 곡 완료 알림 해제
    endOfTrackCancellable?.cancel()
    endOfTrackCancellable = nil

    activateSession()

    let item = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: item)
    player.play()

    isPlaying = true
    syncNowPlaying()

    endOfTrackCancellable = NotificationCenter.default
      .publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        guard let self else { return }

        if self.currentIndex + 1 < self.queue.count {
          self.playNext()
        } else if self.playbackMode == .search && !self.queue.isEmpty {
          self.currentIndex = 0
          self.nowPlaying = self.queue[0]
          self.currentPlayerName = self.queuePlayerNames[0]
          self.playCurrentSong()
        } else {
          self.isPlaying = false
          self.syncNowPlaying()
        }
      }
  }

  func pause() {
    player.pause()
    isPlaying = false
    syncNowPlaying()
  }

  func resume() {
    activateSession()
    player.play()
    isPlaying = true
    syncNowPlaying()
  }

  func toggle() {
    isPlaying ? pause() : resume()
  }

  func stop() {
    endOfTrackCancellable?.cancel()
    endOfTrackCancellable = nil

    player.pause()
    player.replaceCurrentItem(with: nil)

    queue = []
    queuePlayerNames = []
    currentIndex = 0

    isPlaying = false
    nowPlaying = nil
    currentPlayerName = nil
    currentCoverImageName = nil
    clearNowPlaying()
  }

  // MARK: - Time / Seek
  var currentTime: Double {
    let s = player.currentTime().seconds
    return s.isFinite ? max(s, 0) : 0
  }

  var duration: Double {
    let s = player.currentItem?.duration.seconds ?? 0
    return s.isFinite ? max(s, 0) : 0
  }

  func seek(_ seconds: Double) {
    let target = min(max(seconds, 0), duration)
    player.seek(to: CMTime(seconds: target, preferredTimescale: 600))
    syncNowPlaying()
  }

  /// UI(진행바) 동기화용 observer
  func observeTime(
    every interval: Double = 0.5,
    queue: DispatchQueue? = .main,
    _ handler: @escaping (Double) -> Void
  ) -> Any {
    let cm = CMTime(seconds: interval, preferredTimescale: 600)
    return player.addPeriodicTimeObserver(forInterval: cm, queue: queue) { t in
      let s = t.seconds
      handler(s.isFinite ? s : 0)
    }
  }

  func removeObserver(_ token: Any) {
    player.removeTimeObserver(token)
  }
  
  func resetToBeginning(completion: @escaping () -> Void) {
    player.seek(to: .zero) { [weak self] _ in
      guard let self else { return }

      DispatchQueue.main.async {
        self.syncNowPlaying()
        completion()
      }
    }
  }
}

// MARK: - Setup
extension AudioPlaybackService {
  private func setupSession() {
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playback, mode: .default)
    } catch {
      assertionFailure("AVAudioSession category 설정 실패: \(error)")
    }
  }

  private func activateSession() {
    guard !sessionActive else { return }

    do {
      try AVAudioSession.sharedInstance().setActive(true)
      sessionActive = true
    } catch {
      assertionFailure("AVAudioSession 활성화 실패: \(error)")
    }
  }

  private func setupRemoteCommands() {
    guard !remoteConfigured else { return }
    remoteConfigured = true

    let cc = nowPlayingSession.remoteCommandCenter

    // 중복 타겟 제거(안전)
    cc.playCommand.removeTarget(nil)
    cc.pauseCommand.removeTarget(nil)
    cc.togglePlayPauseCommand.removeTarget(nil)
    cc.nextTrackCommand.removeTarget(nil)
    cc.previousTrackCommand.removeTarget(nil)
    cc.changePlaybackPositionCommand.removeTarget(nil)

    cc.playCommand.isEnabled = true
    cc.pauseCommand.isEnabled = true
    cc.togglePlayPauseCommand.isEnabled = true
    cc.nextTrackCommand.isEnabled = true
    cc.previousTrackCommand.isEnabled = true
    cc.changePlaybackPositionCommand.isEnabled = true

    cc.playCommand.addTarget { [weak self] _ in
      self?.resume()
      return .success
    }

    cc.pauseCommand.addTarget { [weak self] _ in
      self?.pause()
      return .success
    }

    cc.togglePlayPauseCommand.addTarget { [weak self] _ in
      self?.toggle()
      return .success
    }

    cc.nextTrackCommand.addTarget { [weak self] _ in
      guard let self else { return .commandFailed }
      let before = self.nowPlaying?.id
      self.playNext()
      return self.nowPlaying?.id != before ? .success : .commandFailed
    }

    cc.previousTrackCommand.addTarget { [weak self] _ in
      guard let self else { return .commandFailed }

      let beforeID = self.nowPlaying?.id
      let shouldRewind = self.currentTime > 3

      self.playPrevious()

      return (shouldRewind || self.nowPlaying?.id != beforeID) ? .success : .commandFailed
    }

    cc.changePlaybackPositionCommand.addTarget { [weak self] event in
      guard let self,
        let event = event as? MPChangePlaybackPositionCommandEvent
      else {
        return .commandFailed
      }

      self.seek(event.positionTime)
      return .success
    }
  }
}

// MARK: - Bundle
extension AudioPlaybackService {

  func playBundle(_ fileName: String) {
    let name = (fileName as NSString).deletingPathExtension
    let ext =
      (fileName as NSString).pathExtension.isEmpty ? "mp3" : (fileName as NSString).pathExtension

    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
      assertionFailure(
        "번들에서 \(name).\(ext) 파일을 찾지 못했습니다. Target Membership / Copy Bundle Resources 확인")
      isPlaying = false
      return
    }

    play(url)
  }
}

// MARK: - Now Playing
extension AudioPlaybackService {
  private func startNowPlayingTick() {
    guard nowPlayingTick == nil else { return }

    let interval = CMTime(seconds: 1, preferredTimescale: 600)
    nowPlayingTick = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
      [weak self] _ in
      self?.syncNowPlaying()
    }
  }

  private func stopNowPlayingTick() {
    if let token = nowPlayingTick {
      player.removeTimeObserver(token)
      nowPlayingTick = nil
    }
  }

  private func syncNowPlaying() {
    guard let song = nowPlaying else { return }

    var info = nowPlayingSession.nowPlayingInfoCenter.nowPlayingInfo ?? [:]
    info[MPMediaItemPropertyTitle] = song.title
    info[MPMediaItemPropertyArtist] = currentPlayerName ?? song.playerId.value
    info[MPMediaItemPropertyPlaybackDuration] = max(duration, 1)
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
    info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
    info[MPNowPlayingInfoPropertyPlaybackQueueIndex] = currentIndex
    info[MPNowPlayingInfoPropertyPlaybackQueueCount] = queue.count

    if let currentCoverImageName,
      let image = UIImage(named: currentCoverImageName)
    {
      info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
        image
      }
    }

    nowPlayingSession.nowPlayingInfoCenter.nowPlayingInfo = info
  }

  fileprivate func clearNowPlaying() {
    nowPlayingSession.nowPlayingInfoCenter.nowPlayingInfo = nil
  }
}
