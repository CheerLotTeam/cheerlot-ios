//
//  DIContainer.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

/// Thread-safe한 DI Container
final class DIContainer {
  static let shared = DIContainer()

  private var singletons: [String: Any] = [:]  // 캐시용
  private var singletonFactories: [String: () -> Any] = [:]  // Lazy 생성용
  private var factories: [String: (DIContainer) -> Any] = [:]
  private let lock = NSRecursiveLock()

  private init() {}

  /// Lazy Singleton 등록 (처음 resolve 시 생성)
  func registerSingleton<T>(
    _ type: T.Type,
    _ factory: @escaping () -> T
  ) {
    lock.lock()
    defer { lock.unlock() }

    let key = String(describing: type)
    singletonFactories[key] = factory
  }

  /// Transient 등록 (매번 생성)
  func register<T>(
    _ type: T.Type,
    _ factory: @escaping (DIContainer) -> T
  ) {
    lock.lock()
    defer { lock.unlock() }

    let key = String(describing: type)
    factories[key] = factory
  }

  /// 의존성 해결
  func resolve<T>(_ type: T.Type) -> T {
    lock.lock()
    defer { lock.unlock() }

    let key = String(describing: type)

    // 1. 이미 생성된 Singleton 캐시 확인
    if let singleton = singletons[key] as? T {
      return singleton
    }

    // 2. Lazy Singleton - 첫 resolve 시 생성 후 캐싱
    if let factory = singletonFactories[key] {
      guard let instance = factory() as? T else {
        fatalError("\(key)의 타입이 일치하지 않습니다.")
      }
      singletons[key] = instance  // 캐싱
      return instance
    }

    // 3. Transient Factory
    if let factory = factories[key] {
      guard let instance = factory(self) as? T else {
        fatalError("\(key)의 타입이 일치하지 않습니다.")
      }
      return instance
    }

    fatalError("\(key)가 등록되지 않았습니다. assemble()을 먼저 호출하세요.")
  }

  /// 모든 의존성 조립
  func assemble() {
    assembleRepositories()
    assembleUseCases()
  }
}

extension DIContainer {

  private func assembleRepositories() {
    registerSingleton(WatchConnectivityRepository.self) {
      WatchConnectivityRepositoryImpl()
    }

    registerSingleton(WatchTeamRepository.self) {
      WatchTeamRepositoryImpl()
    }

    registerSingleton(WatchMemberRepository.self) {
      WatchMemberRepositoryImpl()
    }
  }

  private func assembleUseCases() {
    /// WatchDataSyncUseCase는 앱 생명주기 동안 살아있어야 하므로 lazy singleton으로 등록
    registerSingleton(WatchDataSyncUseCase.self) {
      WatchDataSyncUseCaseImpl(
        watchConnectivityRepository: DIContainer.shared.resolve(WatchConnectivityRepository.self),
        watchTeamRepository: DIContainer.shared.resolve(WatchTeamRepository.self),
        watchMemberRepository: DIContainer.shared.resolve(WatchMemberRepository.self)
      )
    }

    register(TeamFetchUseCase.self) { container in
      TeamFetchUseCaseImpl(
        watchTeamRepository: container.resolve(WatchTeamRepository.self)
      )
    }

    register(LineupFetchUseCase.self) { container in
      LineupFetchUseCaseImpl(
        memberRepository: container.resolve(WatchMemberRepository.self)
      )
    }
  }
}
