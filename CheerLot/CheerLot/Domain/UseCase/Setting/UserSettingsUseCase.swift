//
//  UserSettingsUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation

protocol UserSettingsUseCase {
  /// 앱 아이콘 모드 조회
  func getAppIconMode() -> AppIconMode

  /// 앱 아이콘 모드 저장
  func setAppIconMode(_ mode: AppIconMode)

}
