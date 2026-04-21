//
//  UserSettingsRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

protocol UserSettingsRepository {
  // MARK: - User Preferences

  /// 앱 아이콘 모드를 확인한다
  func getAppIconMode() -> AppIconMode

  /// 앱 아이콘 모드를 지정한다
  func setAppIconMode(_ mode: AppIconMode)

  // MARK: - Team State Cache

  /// 오늘 해당 팀의 라인업 업데이트 여부를 반환한다
  func getLineupUpdatedToday(for teamId: TeamID) -> Bool

  /// 오늘 해당 팀의 라인업 업데이트 여부를 저장한다
  func setLineupUpdatedToday(_ value: Bool, for teamId: TeamID)
}
