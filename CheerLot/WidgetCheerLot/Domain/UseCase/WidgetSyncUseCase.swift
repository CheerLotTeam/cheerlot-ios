//
//  WidgetSyncUseCase.swift
//  WidgetCheerLot
//
//  Created by 이현주 on 4/6/26.
//

import Foundation

protocol WidgetSyncUseCase {
  /// 버전 확인 후 필요하면 동기화
  func syncAndFetch(for teamId: TeamID) async throws -> WidgetGamesInfo

  /// 네트워크 없이 로컬 캐시에서만 조회
  func fetchLocal(for teamId: TeamID) async -> WidgetGamesInfo?
}
