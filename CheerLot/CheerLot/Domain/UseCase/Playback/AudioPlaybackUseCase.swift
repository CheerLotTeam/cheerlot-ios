//
//  AudioPlaybackUseCase.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

/// 앱 전역 오디오 재생 위한 UseCase
protocol AudioPlaybackUseCase {
  /// 현재 재생 중인 응원가 정보
  var nowPlaying: CheerSongInfo? { get }

  /// 현재 재생 중인 곡 선수 이름
  var currentPlayerName: String? { get }

  /// 현재 재생 중인 커버이미지
  var currentCoverImageName: String? { get }

  /// 현재 재생 중 여부
  var isPlaying: Bool { get }

  /// 현재 재생 위치
  var currentTime: Double { get }

  var currentQueueIndex: Int { get }

  var playbackMode: PlaybackMode { get }

  var canSkipManually: Bool { get }

  /// 진행률 계산
  var duration: Double { get }

  /// 단일 재생할 응원가정보
  func play(_ song: CheerSongInfo)

  /// + 선수 이름, 커버 이미지
  func play(
    _ song: CheerSongInfo,
    playerName: String?,
    coverImageName: String?
  )

  /// 재생 큐
  func playQueue(
    _ songs: [CheerSongInfo],
    playerNames: [String],
    startAt index: Int,
    coverImageName: String?,
    mode: PlaybackMode,
    source: PlaySource,
    isGameDay: Bool
  )

  /// 다음곡
  func playNext()

  /// 이전곡
  func playPrevious()

  /// 일시정지
  func pause()

  /// 일시정지 된 곡 다시 재생
  func resume()

  /// 현재 재생 상태 토글
  func toggle()

  /// 재생 중지 및 초기화
  func stop()

  /// 현재 곡 특정 위치 이동
  func seek(_ seconds: Double)

  /// 관찰자 (진행바와 시간 UI 갱신)
  func observeTime(
    every interval: Double,
    queue: DispatchQueue?,
    _ handler: @escaping (Double) -> Void
  ) -> Any

  /// 관찰자 제거
  func removeObserver(_ token: Any)

  func resetToBeginning(completion: @escaping () -> Void)
}
