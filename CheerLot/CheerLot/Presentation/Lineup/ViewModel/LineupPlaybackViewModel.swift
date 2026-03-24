//
//  LineupPlaybackViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation
import Observation

@Observable
final class LineupPlaybackViewModel {
  let startIndex: Int

  var lineupPlayers: [LineupPlayerVO] = []
  var asset: LineupPlaybackAssetVO?
  var gameDate: String = " "
  var teamsText: String = " "

  var carouselItems: [CarouselItemVO] {
    lineupPlayers.flatMap { player in
      player.cheerSongs.map { song in
        CarouselItemVO(id: "\(player.id)-\(song.id)", player: player, cheerSong: song)
      }
    }
  }

  var currentPlaybackIndex: Int
  var isSyncingFromPlayback = false
  var isPlaying = false

  @ObservationIgnored
  @Injected(PlayLineupSongsUseCase.self) private var playLineupSongsUseCase

  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  @ObservationIgnored
  @Injected(LineupManagementUseCase.self) private var lineupManagementUseCase

  @ObservationIgnored
  @Injected(TeamInfoUseCase.self) private var teamInfoUseCase

  private var timeObserver: Any?

  init(startIndex: Int) {
    self.startIndex = startIndex
    self.currentPlaybackIndex = startIndex
  }

  deinit {
    stopObservingPlayback()
  }

  func onAppear() async {
    await loadData()

    let flattenedItems = lineupPlayers.flatMap { player in
      player.cheerSongs.map { song in
        (playerName: player.name, song: song.toEntity())
      }
    }

    guard !flattenedItems.isEmpty else { return }

    if playLineupSongsUseCase.duration > 0 {
      playLineupSongsUseCase.resume()
      isPlaying = playLineupSongsUseCase.isPlaying
      startObservingPlayback()
      return
    }

    guard flattenedItems.indices.contains(startIndex) else { return }

    let songs = flattenedItems.map(\.song)
    let playerNames = flattenedItems.map(\.playerName)

    playLineupSongsUseCase.playQueue(
      songs,
      playerNames: playerNames,
      startAt: startIndex
    )

    currentPlaybackIndex = startIndex
    isPlaying = playLineupSongsUseCase.isPlaying
    startObservingPlayback()
  }

  func pausePlayback() {
    playLineupSongsUseCase.pause()
    isPlaying = false
  }

  func stopPlayback() {
    stopObservingPlayback()
    playLineupSongsUseCase.stop()
    isPlaying = false
  }

  func togglePlayback() {
    playLineupSongsUseCase.toggle()
    isPlaying = playLineupSongsUseCase.isPlaying
  }

  func didScrollToCard(at index: Int) {
    guard !isSyncingFromPlayback else { return }
    guard index != playLineupSongsUseCase.currentIndex else { return }

    playLineupSongsUseCase.play(at: index)
    currentPlaybackIndex = index
    isPlaying = playLineupSongsUseCase.isPlaying
  }

  // MARK: - Private

  private func loadData() async {
    guard let teamInfo = teamSelectionUseCase.getCurrentTeam() else { return }
    let teamId = teamInfo.id

    asset = LineupPlaybackAssetVO(base: TeamAssetVO(teamId))

    guard let data = try? await lineupManagementUseCase.loadCurrentLineup(for: teamId) else {
      return
    }

    lineupPlayers = data.lineupPlayers.map { LineupPlayerVO(from: $0) }

    let opponentTeamInfo = data.opponentTeamId.flatMap { teamInfoUseCase.getTeamInfo($0) }
    let gameInfoVO = LineupGameInfoVO(
      teamInfo: teamInfo,
      opponentTeamInfo: opponentTeamInfo,
      gameInfo: data.gameInfo
    )

    gameDate = gameInfoVO.gameDateText
    teamsText = gameInfoVO.gameTeamsText
  }

  private func startObservingPlayback() {
    guard timeObserver == nil else { return }

    timeObserver = playLineupSongsUseCase.observeTime(every: 0.5, queue: .main) { [weak self] _ in
      guard let self else { return }

      let queueIndex = self.playLineupSongsUseCase.currentIndex
      guard queueIndex != self.currentPlaybackIndex else { return }

      self.isSyncingFromPlayback = true
      self.currentPlaybackIndex = queueIndex

      DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        self.isSyncingFromPlayback = false
      }
    }
  }

  private func stopObservingPlayback() {
    if let token = timeObserver {
      playLineupSongsUseCase.removeObserver(token)
      timeObserver = nil
    }
  }
}
