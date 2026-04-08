//
//  GameScheduleRepositoryImpl.swift
//  WidgetCheerLot
//
//  Created by 이현주 on 4/6/26.
//

import Foundation

final class GameScheduleRepositoryImpl: GameScheduleRepository {
  private let defaults: UserDefaults?

  init() {
    self.defaults = UserDefaults(suiteName: AppGroup.id)
  }

  func saveGameSchedule(_ schedule: TeamGameScheduleInfo, for teamId: TeamID) {
    let dto = GameScheduleStorageDTO.from(schedule)
    guard let data = try? JSONEncoder().encode(dto) else { return }
    defaults?.set(data, forKey: storageKey(for: teamId))
  }

  func fetchGameSchedule(for teamId: TeamID) -> TeamGameScheduleInfo? {
    guard
      let data = defaults?.data(forKey: storageKey(for: teamId)),
      let dto = try? JSONDecoder().decode(GameScheduleStorageDTO.self, from: data)
    else { return nil }
    return dto.toDomain()
  }

  private func storageKey(for teamId: TeamID) -> String {
    "\(UserDefaultsKey.Widget.gameSchedule).\(teamId.value)"
  }
}
