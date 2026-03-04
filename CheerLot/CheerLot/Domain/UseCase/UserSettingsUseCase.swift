//
//  UserSettingsUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

protocol UserSettingsUseCase {
  /// 최근 라인업 보기 여부 조회
  func getShowRecentLineup() -> Bool

  /// 최근 라인업 보기 설정
  func setShowRecentLineup(_ value: Bool)

  /// 최근 라인업 보기 false로 초기화
  func resetShowRecentLineup()
}
