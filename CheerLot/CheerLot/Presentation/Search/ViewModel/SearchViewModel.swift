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

  private(set) var currentTeam: TeamInfo

  // MARK: - Dependencies
  @ObservationIgnored
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase

  @ObservationIgnored
  @Injected(TeamPlayersSyncUseCase.self) private var teamPlayersSyncUseCase
  
  @ObservationIgnored
  @Injected(PlaySearchSongsUseCase.self) private var playSearchSongsUseCase

  private var players: [PlayerInfo] = []

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
       selectedTeam.id != currentTeam.id {
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
  
  func didTapResult(_ result: SearchResultVO) {
    guard result.hasSong else { return }

    let coverImageName = TeamAssetVO(currentTeam.id).coverImageName
    playSearchSongsUseCase.play(
      result: result,
      coverImageName: coverImageName
    )
  }

  // MARK: - Private
  private func loadPlayers() async {
    isLoading = true
    errorMessage = nil

    do {
      let playerEntities = try await teamPlayersSyncUseCase.getAllPlayers(currentTeam.id)
      players = playerEntities
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

    results = players
      .compactMap { player in
        guard let range = player.name.range(of: keyword) else { return nil }
        let matchIndex = player.name.distance(from: player.name.startIndex, to: range.lowerBound)

        return SearchResultVO(
          id: player.id.value,
          playerId: player.id,
          playerName: player.name,
          backNumber: player.backNumber,
          cheerSongs: player.cheerSongs,
          matchIndex: matchIndex
        )
      }
      .sorted { lhs, rhs in
        if lhs.matchIndex != rhs.matchIndex {
          return lhs.matchIndex < rhs.matchIndex
        }
        return lhs.playerName.localizedCompare(rhs.playerName) == .orderedAscending
      }
  }
}
