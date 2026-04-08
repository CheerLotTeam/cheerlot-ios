//
//  GameScheduleRepository.swift
//  WidgetCheerLot
//
//  Created by 이현주 on 4/6/26.
//

import Foundation

protocol GameScheduleRepository {
  func saveGameSchedule(_ schedule: TeamGameScheduleInfo, for teamId: TeamID)
  func fetchGameSchedule(for teamId: TeamID) -> TeamGameScheduleInfo?
}
