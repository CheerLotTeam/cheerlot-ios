//
//  SearchViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 3/1/26.
//

import Foundation
import Observation

@Observable
final class SearchViewModel {
  // MARK: - State
  var query: String = ""
  var results: [SearchResultVO] = []
  var isLoading = false
  var errorMessage: String?
  var showToast = false
  var toastMessage = ""

  private(set) var currentTeam: TeamInfo

  // MARK: - Dependencies
  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  @ObservationIgnored
  @Injected(TeamPlayersSyncUseCase.self) private var teamPlayersSyncUseCase

  @ObservationIgnored
  @Injected(PlaySearchSongsUseCase.self) private var playSearchSongsUseCase

  private var allRows: [SearchResultVO] = []

  // MARK: - Init
  init() {
    let teamSelectionUseCase = DIContainer.shared.resolve(TeamSelectionUseCase.self)
    self.currentTeam = teamSelectionUseCase.getCurrentTeam() ?? TeamDataSource.toEntity(.samsung)
  }

  // MARK: - Derived State
  var trimmedQuery: String {
    query.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var isQueryEmpty: Bool {
    trimmedQuery.isEmpty
  }

  var hasQuery: Bool {
    !query.isEmpty
  }

  // MARK: - Lifecycle
  func onAppear() async {
    if let selectedTeam = teamSelectionUseCase.getCurrentTeam(),
      selectedTeam.id != currentTeam.id
    {
      currentTeam = selectedTeam
    }

    await loadPlayers()
    applySearch()
  }

  func didUpdateSelectedTeam(_ team: TeamInfo) async {
    guard currentTeam.id != team.id else { return }
    currentTeam = team
    query = ""
    results = []
    await loadPlayers()
  }

  // MARK: - Actions
  func updateQuery(_ newValue: String) {
    query = String(newValue.prefix(12))
    applySearch()
  }

  func clearQuery() {
    query = ""
    results = []
  }

  func showNoSongToast() {
    toastMessage = "아직 개인 응원가가 없어요"
    showToast = true
  }

  func didTapResult(_ result: SearchResultVO) {
    guard result.hasSong else { return }

    let coverImageName = TeamAssetVO(currentTeam.id).coverImageName
    playSearchSongsUseCase.play(
      selectedResult: result,
      allResults: results,
      coverImageName: coverImageName
    )
  }

  // MARK: - Private
  private func loadPlayers() async {
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

      allRows = sortedPlayers.flatMap { player in
        if player.cheerSongs.isEmpty {
          return [
            SearchResultVO(
              id: "\(player.id.value)-empty",
              playerId: player.id,
              playerName: player.name,
              backNumber: player.backNumber,
              song: nil,
              matchIndex: 0
            )
          ]
        } else {
          return player.cheerSongs.map { song in
            SearchResultVO(
              id: "\(player.id.value)-\(song.id)",
              playerId: player.id,
              playerName: player.name,
              backNumber: player.backNumber,
              song: song,
              matchIndex: 0
            )
          }
        }
      }

      isLoading = false
    } catch {
      isLoading = false
      errorMessage = "선수 데이터를 불러올 수 없습니다: \(error.localizedDescription)"
    }
  }

  private func applySearch() {
    let keyword = trimmedQuery
    guard !keyword.isEmpty else {
      results = []
      return
    }

    results =
      allRows
      .compactMap { row in
        guard let range = row.playerName.range(of: keyword) else { return nil }
        let index = row.playerName.distance(from: row.playerName.startIndex, to: range.lowerBound)

        return SearchResultVO(
          id: row.id,
          playerId: row.playerId,
          playerName: row.playerName,
          backNumber: row.backNumber,
          song: row.song,
          matchIndex: index
        )
      }
      .sorted { lhs, rhs in
        if lhs.hasSong != rhs.hasSong {
          return lhs.hasSong && !rhs.hasSong
        }

        return lhs.playerName.localizedCompare(rhs.playerName) == .orderedAscending
      }
  }
}
