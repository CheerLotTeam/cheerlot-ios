//
//  DIContainer.swift
//  CheerLot
//
//  Created by 이승진 on 9/5/25.
//

import Foundation

/// Thread-safe한 DI Container
final class DIContainer {
  static let shared = DIContainer()

  private var singletons: [String: Any] = [:] // 캐시용
  private var singletonFactories: [String: () -> Any] = [:] // Lazy 생성용
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
//    let instance = factory()
//    singletons[key] = instance
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
      singletons[key] = instance // 캐싱
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
    assembleService()
    assembleRepositories()
    assembleUseCases()
  }
}

extension DIContainer {

  private func assembleService() {
    registerSingleton(AudioPlaybackService.self) {
      AudioPlaybackService()
    }

    registerSingleton(LineupPlaybackService.self) {
      LineupPlaybackService()
    }
  }

  private func assembleRepositories() {
    registerSingleton(UserSettingsRepository.self) {
      UserSettingsRepositoryImpl()
    }

    registerSingleton(TeamSelectionRepository.self) {
      TeamSelectionRepositoryImpl()
    }

    registerSingleton(TeamInfoRepository.self) {
      TeamInfoRepositoryImpl()
    }

    registerSingleton(TeamLocalRepository.self) {
      TeamLocalRepositoryImpl(modelContainer: LocalStorage.shared.modelContainer)
    }

    registerSingleton(TeamRemoteRepository.self) {
      TeamRemoteRepositoryImpl()
    }

    registerSingleton(PlayerLocalRepository.self) {
      PlayerLocalRepositoryImpl(modelContainer: LocalStorage.shared.modelContainer)
    }

    registerSingleton(PlayerRemoteRepository.self) {
      PlayerRemoteRepositoryImpl()
    }

    registerSingleton(WatchSyncRepository.self) {
      WatchSyncRepositoryImpl()
    }
  }

  private func assembleUseCases() {
    register(AudioPlaybackUseCase.self) { container in
      AudioPlaybackUseCaseImpl(
        audioPlayer: container.resolve(AudioPlaybackService.self)
      )
    }

    register(PlayTeamMembersUseCase.self) { container in
      PlayTeamMembersUseCaseImpl(
        audioPlaybackUseCase: container.resolve(AudioPlaybackUseCase.self)
      )
    }

    register(PlayLineupSongsUseCase.self) { container in
      PlayLineupSongsUseCaseImpl(
        lineupAudioPlayer: container.resolve(LineupPlaybackService.self)
      )
    }

    register(PlaySearchSongsUseCase.self) { container in
      PlaySearchSongsUseCaseImpl(
        audioPlaybackUseCase: container.resolve(AudioPlaybackUseCase.self)
      )
    }

    register(UserSettingsUseCase.self) { container in
      UserSettingsUseCaseImpl(
        userSettingsRepository: container.resolve(UserSettingsRepository.self)
      )
    }

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

    register(TeamPlayersSyncUseCase.self) { container in
      TeamPlayersSyncUseCaseImpl(
        teamLocalRepository: container.resolve(TeamLocalRepository.self),
        teamRemoteRepository: container.resolve(TeamRemoteRepository.self),
        playerLocalRepository: container.resolve(PlayerLocalRepository.self),
        playerRemoteRepository: container.resolve(PlayerRemoteRepository.self)
      )
    }

    register(LineupSyncUseCase.self) { container in
      LineupSyncUseCaseImpl(
        teamLocalRepository: container.resolve(TeamLocalRepository.self),
        teamRemoteRepository: container.resolve(TeamRemoteRepository.self),
        playerLocalRepository: container.resolve(PlayerLocalRepository.self),
        playerRemoteRepository: container.resolve(PlayerRemoteRepository.self),
        userSettingsRepository: container.resolve(UserSettingsRepository.self)
      )
    }

    register(TeamGameInfoSyncUseCase.self) { container in
      TeamGameInfoSyncUseCaseImpl(
        teamLocalRepository: container.resolve(TeamLocalRepository.self),
        teamRemoteRepository: container.resolve(TeamRemoteRepository.self)
      )
    }

    register(LineupManagementUseCase.self) { container in
      LineupManagementUseCaseImpl(
        teamLocalRepository: container.resolve(TeamLocalRepository.self),
        teamRemoteRepository: container.resolve(TeamRemoteRepository.self),
        playerLocalRepository: container.resolve(PlayerLocalRepository.self),
        playerRemoteRepository: container.resolve(PlayerRemoteRepository.self),
        userSettingsRepository: container.resolve(UserSettingsRepository.self),
        watchSyncRepository: container.resolve(WatchSyncRepository.self)
      )
    }

    register(LineupChangeUseCase.self) { container in
      LineupChangeUseCaseImpl(
        playerLocalRepository: container.resolve(PlayerLocalRepository.self),
        watchSyncRepository: container.resolve(WatchSyncRepository.self)
      )
    }
  }
}
