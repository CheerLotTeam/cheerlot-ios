//
//  UserSettingsRepository.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

protocol UserSettingsRepository {
  /// 최신 라인업 보기 설정을 확인한다
  func getShowRecentLineup() -> Bool

  /// 최신 라인업 보기 설정 값을 지정한다
  func setShowRecentLineup(_ value: Bool)

  /// 최신 라인업 보기 설정 값을 false로 초기화한다
  func resetShowRecentLineup()
}
