//
//  GameScheduleRepository.swift
//  WidgetCheerLot
//
//  Created by 이현주 on 4/6/26.
//

import Foundation

protocol GameScheduleRepository {
  /// 팀의 3경기 일정을 로컬(UserDefaults)에 저장
  func saveGameSchedule(_ schedule: TeamGameScheduleInfo, for teamId: TeamID)

  /// 로컬(UserDefaults)에 캐시된 3경기 일정을 반환. 저장된 데이터가 없으면 nil
  func fetchGameSchedule(for teamId: TeamID) -> TeamGameScheduleInfo?
}
