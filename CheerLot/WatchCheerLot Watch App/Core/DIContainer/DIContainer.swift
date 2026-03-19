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

  private var singletons: [String: Any] = [:]
  private var factories: [String: (DIContainer) -> Any] = [:]
  private let lock = NSRecursiveLock()

  private init() {}

  /// Singleton 등록 (한 번만 생성)
  func registerSingleton<T>(
    _ type: T.Type,
    _ factory: @escaping () -> T
  ) {
    lock.lock()
    defer { lock.unlock() }

    let key = String(describing: type)
    let instance = factory()
    singletons[key] = instance
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

    // 1. Singleton 확인
    if let singleton = singletons[key] as? T {
      return singleton
    }

    // 2. Factory 확인
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
    registerSingleton(WatchTeamRepository.self) {
      WatchTeamRepositoryImpl()
    }

    registerSingleton(WatchMemberRepository.self) {
      WatchMemberRepositoryImpl()
    }

    // WatchTeamRepository, WatchMemberRepository 등록 이후에 등록 (의존성 순서)
    registerSingleton(WatchConnectivityRepository.self) {
      WatchConnectivityRepositoryImpl(
        watchTeamRepository: DIContainer.shared.resolve(WatchTeamRepository.self),
        memberRepository: DIContainer.shared.resolve(WatchMemberRepository.self)
      )
    }
  }

  private func assembleUseCases() {
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
