//
//  TeamMembersViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 2/20/26.
//

import Foundation
import Observation
import WidgetKit

@Observable
final class TeamMembersViewModel {

  // MARK: - State
  var currentTeam: TeamInfo
  var rows: [TeamMembersSongVO] = []
  var isLoading = false
  var errorMessage: String?
  var showToast = false
  var toastMessage = ""

  private var players: [PlayerInfo] = []

  var totalSongCount: Int {
    rows.filter { $0.song != nil }.count
  }

  // MARK: - Dependencies
  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  @ObservationIgnored
  @Injected(TeamPlayersSyncUseCase.self) private var teamPlayersSyncUseCase

  @ObservationIgnored
  @Injected(PlayTeamMembersUseCase.self) private var playTeamMembersUseCase

  @ObservationIgnored
  @Injected(AudioPlaybackUseCase.self) private var audioPlaybackUseCase

  @ObservationIgnored
  @Injected(TeamGameInfoUseCase.self) private var teamGameInfoUseCase

  private var isGameDay = false

  // MARK: - Init
  init() {
    let teamSelectionUseCase = DIContainer.shared.resolve(TeamSelectionUseCase.self)
    self.currentTeam =
      teamSelectionUseCase.getCurrentTeam()
      ?? TeamDataSource.toEntity(.samsung)
  }

  // MARK: - Action
  func onAppear() async {
    if let selectedTeam = teamSelectionUseCase.getCurrentTeam(),
      selectedTeam.id != currentTeam.id
    {
      currentTeam = selectedTeam
    }

    await syncData()
    await loadData()
    await loadIsGameDay()
    syncPlaybackModeIfNeeded()
  }

  func refresh() async {
    await syncData()
    await loadData()
  }

  func didUpdateSelectedTeam(_ team: TeamInfo) async {
    guard currentTeam.id != team.id else { return }
    currentTeam = team
    await syncData()
    await loadData()
  }

  func didTapSong(_ item: TeamMembersSongVO) {
    guard item.song != nil else {
      showNoSongToast()
      return
    }

    playTeamMembersUseCase.playSelected(
      row: item,
      allRows: rows,
      currentTeam: currentTeam,
      isGameDay: isGameDay
    )
  }

  func didTapPlayAll() {
    playTeamMembersUseCase.playAll(
      rows: rows,
      currentTeam: currentTeam,
      isGameDay: isGameDay
    )
  }

  func showNoSongToast() {
    toastMessage = "아직 개인 응원가가 없어요"
    showToast = true
  }

  /// 검색 재생 중이면 현재 곡 기준으로 전체선수용 일반 재생 큐로 전환하는 함수
  func syncPlaybackModeIfNeeded() {
    guard audioPlaybackUseCase.playbackMode == .search else { return }
    guard let nowPlaying = audioPlaybackUseCase.nowPlaying else { return }

    let playableRows = rows.filter { $0.song != nil }
    guard !playableRows.isEmpty else { return }

    guard
      let startIndex = playableRows.firstIndex(where: {
        $0.song?.id == nowPlaying.id && $0.playerId == nowPlaying.playerId
      })
    else {
      return
    }

    let songs = playableRows.compactMap(\.song)
    let playerNames = playableRows.map(\.playerName)
    let coverImageName = TeamAssetVO(currentTeam.id).coverImageName

    audioPlaybackUseCase.playQueue(
      songs,
      playerNames: playerNames,
      startAt: startIndex,
      coverImageName: coverImageName,
      mode: .normal,
      source: .teamMembers,
      isGameDay: isGameDay
    )
  }

  // MARK: - Private
  private func loadIsGameDay() async {
    isGameDay = await teamGameInfoUseCase.isGameDay(currentTeam.id)
  }

  private func syncData() async {
    do {
      try await teamPlayersSyncUseCase.syncIfNeeded(currentTeam.id)
    } catch {
      print("Team players sync failed: \(error)")
    }
  }

  private func loadData() async {
    isLoading = true
    errorMessage = nil

    do {
      let playerEntities = try await teamPlayersSyncUseCase.getAllPlayers(currentTeam.id)

      let sortedPlayers = playerEntities.sorted { lhs, rhs in
        let lhsHasSong = !lhs.cheerSongs.isEmpty
        let rhsHasSong = !rhs.cheerSongs.isEmpty

        if lhsHasSong != rhsHasSong {
          return lhsHasSong && !rhsHasSong
        }

        return lhs.name.localizedCompare(rhs.name) == .orderedAscending
      }

      players = sortedPlayers

      rows = sortedPlayers.flatMap { player in
        if player.cheerSongs.isEmpty {
          return [
            TeamMembersSongVO(
              id: "\(player.id.value)-empty",
              playerId: player.id,
              playerName: player.name,
              backNumber: player.backNumber,
              song: nil
            )
          ]
        } else {
          return player.cheerSongs.map { song in
            TeamMembersSongVO(
              id: "\(player.id.value)-\(song.id)",
              playerId: player.id,
              playerName: player.name,
              backNumber: player.backNumber,
              song: song
            )
          }
        }
      }

      isLoading = false
      saveWidgetSongCount()
    } catch {
      isLoading = false
      errorMessage = "전체 선수 데이터를 불러올 수 없습니다: \(error.localizedDescription)"
    }
  }

  private func saveWidgetSongCount() {
    UserDefaults(suiteName: AppGroup.id)?.set(
      totalSongCount, forKey: UserDefaultsKey.Widget.totalSongCount)
    WidgetCenter.shared.reloadTimelines(ofKind: "HomePlaybackWidget")
  }
}
