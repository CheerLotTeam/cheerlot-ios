//
//  WidgetDIContainer.swift
//  CheerLot
//
//  Created by 이현주 on 4/5/26.
//

import Foundation

final class WidgetDIContainer {
  static let shared = WidgetDIContainer()

  private var singletons: [String: Any] = [:]
  private var singletonFactories: [String: () -> Any] = [:]
  private var factories: [String: (WidgetDIContainer) -> Any] = [:]
  private let lock = NSRecursiveLock()

  private init() {}

  func registerSingleton<T>(_ type: T.Type, _ factory: @escaping () -> T) {
    lock.lock()
    defer { lock.unlock() }
    singletonFactories[String(describing: type)] = factory
  }

  func register<T>(_ type: T.Type, _ factory: @escaping (WidgetDIContainer) -> T) {
    lock.lock()
    defer { lock.unlock() }
    factories[String(describing: type)] = factory
  }

  func resolve<T>(_ type: T.Type) -> T {
    lock.lock()
    defer { lock.unlock() }

    let key = String(describing: type)

    if let singleton = singletons[key] as? T {
      return singleton
    }

    if let factory = singletonFactories[key] {
      guard let instance = factory() as? T else {
        fatalError("\(key)의 타입이 일치하지 않습니다.")
      }
      singletons[key] = instance
      return instance
    }

    if let factory = factories[key] {
      guard let instance = factory(self) as? T else {
        fatalError("\(key)의 타입이 일치하지 않습니다.")
      }
      return instance
    }

    fatalError("\(key)가 등록되지 않았습니다. assemble()을 먼저 호출하세요.")
  }

  func assemble() {
    assembleRepositories()
    assembleUseCases()
  }
}

extension WidgetDIContainer {
  private func assembleRepositories() {
    registerSingleton(TeamSelectionRepository.self) {
      TeamSelectionRepositoryImpl()
    }

    registerSingleton(TeamInfoRepository.self) {
      TeamInfoRepositoryImpl()
    }

    registerSingleton(TeamLocalRepository.self) {
      TeamLocalRepositoryImpl(modelContainer: WidgetLocalStorage.shared.modelContainer)
    }

    registerSingleton(TeamRemoteRepository.self) {
      TeamRemoteRepositoryImpl()
    }

    registerSingleton(PlayerLocalRepository.self) {
      PlayerLocalRepositoryImpl(modelContainer: WidgetLocalStorage.shared.modelContainer)
    }

    registerSingleton(PlayerRemoteRepository.self) {
      PlayerRemoteRepositoryImpl()
    }

    registerSingleton(GameScheduleRepository.self) {
      GameScheduleRepositoryImpl()
    }

    registerSingleton(UserSettingsRepository.self) {
      UserSettingsRepositoryImpl()
    }
  }

  private func assembleUseCases() {
    register(TeamSelectionUseCase.self) { container in
      TeamSelectionUseCaseImpl(
        teamSelectionRepository: container.resolve(TeamSelectionRepository.self)
      )
    }

    register(TeamInfoUseCase.self) { container in
      TeamInfoUseCaseImpl(
        teamInfoRepository: container.resolve(TeamInfoRepository.self)
      )
    }

    register(WidgetSyncUseCase.self) { container in
      WidgetSyncUseCaseImpl(
        teamLocalRepository: container.resolve(TeamLocalRepository.self),
        teamRemoteRepository: container.resolve(TeamRemoteRepository.self),
        playerLocalRepository: container.resolve(PlayerLocalRepository.self),
        playerRemoteRepository: container.resolve(PlayerRemoteRepository.self),
        gameScheduleRepository: container.resolve(GameScheduleRepository.self),
        userSettingsRepository: container.resolve(UserSettingsRepository.self)
      )
    }
  }
}
