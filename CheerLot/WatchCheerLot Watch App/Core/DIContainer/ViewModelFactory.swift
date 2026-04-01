//
//  ViewModelFactory.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

@MainActor
final class ViewModelFactory {

  static let shared = ViewModelFactory()

  private init() {}

  // MARK: - Lineup
  func createLineupViewModel() -> LineupViewModel {
    LineupViewModel()
  }
}
