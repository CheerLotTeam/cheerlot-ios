//
//  AudioPlaybackService.swift
//  CheerLot
//
//  Created by 이승진 on 2/20/26.
//

import AVFoundation
import Observation
import MediaPlayer

@Observable
/// 앱 전역 오디오 재생을 담당하는 서비스
final class AudioPlaybackService {

  // MARK: - Core
  private let player = AVPlayer()

  // LockScreen NowPlayingInfo 주기 갱신용
  private var nowPlayingTick: Any?

  // RemoteCommand 중복 등록 방지
  private var remoteConfigured = false

  // MARK: - State (UI Binding)
  var nowPlaying: CheerSongInfo?
  var isPlaying: Bool = false

  // MARK: - Init
  init() {
    setupSession()
    setupRemoteCommands()
    startNowPlayingTick()
  }

  deinit {
    stopNowPlayingTick()
  }

  // MARK: - Playback
  func play(_ song: CheerSongInfo) {
    nowPlaying = song

    if song.audioURL.hasPrefix("http"),
       let url = URL(string: song.audioURL) {
      play(url)
      return
    }

    playBundle(song.audioURL)
  }

  func play(_ url: URL) {
    player.replaceCurrentItem(with: AVPlayerItem(url: url))
    player.play()

    isPlaying = true
    syncNowPlaying()
  }

  func pause() {
    player.pause()
    isPlaying = false
    syncNowPlaying()
  }

  func resume() {
    player.play()
    isPlaying = true
    syncNowPlaying()
  }

  func toggle() {
    isPlaying ? pause() : resume()
  }

  func stop() {
    player.pause()
    player.replaceCurrentItem(with: nil)

    isPlaying = false
    nowPlaying = nil
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
    player.seek(to: CMTime(seconds: max(seconds, 0), preferredTimescale: 600))
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
}

// MARK: - Setup
private extension AudioPlaybackService {

  func setupSession() {
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playback, mode: .default)
      try session.setActive(true)
    } catch {
      assertionFailure("AVAudioSession 설정 실패: \(error)")
    }
  }

  func setupRemoteCommands() {
    guard !remoteConfigured else { return }
    remoteConfigured = true

    let cc = MPRemoteCommandCenter.shared()

    // 중복 타겟 제거(안전)
    cc.playCommand.removeTarget(nil)
    cc.pauseCommand.removeTarget(nil)
    cc.togglePlayPauseCommand.removeTarget(nil)

    cc.playCommand.isEnabled = true
    cc.pauseCommand.isEnabled = true
    cc.togglePlayPauseCommand.isEnabled = true

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
  }
}

// MARK: - Bundle
extension AudioPlaybackService {

  func playBundle(_ fileName: String) {
    let name = (fileName as NSString).deletingPathExtension
    let ext = (fileName as NSString).pathExtension.isEmpty ? "mp3" : (fileName as NSString).pathExtension

    guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
      assertionFailure("번들에서 \(name).\(ext) 파일을 찾지 못했습니다. Target Membership / Copy Bundle Resources 확인")
      isPlaying = false
      return
    }

    play(url)
  }
}

// MARK: - Now Playing
private extension AudioPlaybackService {

  func startNowPlayingTick() {
    guard nowPlayingTick == nil else { return }

    let interval = CMTime(seconds: 1, preferredTimescale: 600)
    nowPlayingTick = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
      self?.syncNowPlaying()
    }
  }

  func stopNowPlayingTick() {
    if let token = nowPlayingTick {
      player.removeTimeObserver(token)
      nowPlayingTick = nil
    }
  }

  func syncNowPlaying() {
    guard let song = nowPlaying else { return }

    var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
    info[MPMediaItemPropertyTitle] = song.title
    info[MPMediaItemPropertyArtist] = song.playerId.value
    info[MPMediaItemPropertyPlaybackDuration] = max(duration, 1)
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
    info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

    MPNowPlayingInfoCenter.default().nowPlayingInfo = info
  }

  func clearNowPlaying() {
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
  }
}
