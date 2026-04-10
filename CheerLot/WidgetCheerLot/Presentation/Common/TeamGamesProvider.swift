//
//  TeamGamesProvider.swift
//  CheerLot
//
//  Created by 이현주 on 4/6/26.
//

import WidgetKit

struct TeamGamesProvider: TimelineProvider {
  @Injected(TeamSelectionUseCase.self) private var teamSelectionUseCase
  @Injected(TeamInfoUseCase.self) private var teamInfoUseCase
  @Injected(WidgetSyncUseCase.self) private var widgetSyncUseCase

  // MARK: - Placeholder

  func placeholder(in context: Context) -> TeamGamesEntry {
    .preview
  }

  // MARK: - Snapshot

  func getSnapshot(in context: Context, completion: @escaping (TeamGamesEntry) -> Void) {
    Task {
      completion(await fetchEntry(useSync: false))
    }
  }

  // MARK: - Timeline

  func getTimeline(in context: Context, completion: @escaping (Timeline<TeamGamesEntry>) -> Void) {
    Task {
      let entry = await fetchEntry(useSync: true)
      let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate()))
      completion(timeline)
    }
  }

  // MARK: - Private

  private func fetchEntry(useSync: Bool) async -> TeamGamesEntry {
    guard let teamInfo = teamSelectionUseCase.getCurrentTeam() else {
      return .fallback
    }

    if useSync, let result = try? await widgetSyncUseCase.syncAndFetch(for: teamInfo.id) {
      return buildEntry(from: result, teamInfo: teamInfo)
    }

    if let result = await widgetSyncUseCase.fetchLocal(for: teamInfo.id) {
      return buildEntry(from: result, teamInfo: teamInfo)
    }

    return .fallback
  }

  private func buildEntry(from result: WidgetGamesInfo, teamInfo: TeamInfo) -> TeamGamesEntry {
    buildEntry(
      teamInfo: teamInfo,
      schedule: result.schedule,
      gameStatus: result.gameStatus
    )
  }

  private func buildEntry(
    teamInfo: TeamInfo,
    schedule: TeamGameScheduleInfo,
    gameStatus: GameStatus
  ) -> TeamGamesEntry {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let games = schedule.recentGames.map { info in
      let opponentInfo = info.opponentTeamId.flatMap { teamInfoUseCase.getTeamInfo($0) }
      return Game(
        date: dateFormatter.date(from: info.date) ?? .now,
        hasGame: info.hasGame,
        starterPitcherName: info.starterPitcherName,
        opponentId: info.opponentTeamId?.value,
        opponentShortName: opponentInfo?.shortName,
        opponentLongName: opponentInfo?.longName,
        isHome: info.isHome
      )
    }

    return TeamGamesEntry(
      date: .now,
      teamId: teamInfo.id.value,
      teamShortName: teamInfo.shortName,
      teamLongName: teamInfo.longName,
      gameSchedule: games,
      gameStatus: mapStatus(gameStatus)
    )
  }

  private func mapStatus(_ gameStatus: GameStatus) -> WidgetGameStatus {
    switch gameStatus {
    case .playingToday: return .playingToday
    case .offDay: return .offDay
    case .seasonEnded: return .seasonEnded
    }
  }

  // 서버 업데이트 시간에 맞춰 00시 15분 호출
  private func nextUpdateDate() -> Date {
    let calendar = Calendar.current
    let tomorrow = calendar.date(byAdding: .day, value: 1, to: .now) ?? .now
    let midnight = calendar.startOfDay(for: tomorrow)
    return calendar.date(byAdding: .minute, value: 15, to: midnight) ?? midnight
  }
}
