//
//  WidgetLocalStorage.swift
//  CheerLot
//
//  Created by 이현주 on 4/5/26.
//

import Foundation
import SwiftData

final class WidgetLocalStorage {
  static let shared = WidgetLocalStorage()

  private init() {}

  lazy var modelContainer: ModelContainer = {
    let schema = Schema([
      Team.self,
      Player.self,
      CheerSong.self,
    ])

    let configuration = ModelConfiguration(
      isStoredInMemoryOnly: false,
      groupContainer: .identifier(AppGroup.id)
    )

    do {
      // 마이그레이션 없이 기존 store를 그대로 열기
      return try ModelContainer(for: schema, configurations: configuration)
    } catch {
      fatalError("Widget ModelContainer 생성 실패: \(error)")
    }
  }()
}
