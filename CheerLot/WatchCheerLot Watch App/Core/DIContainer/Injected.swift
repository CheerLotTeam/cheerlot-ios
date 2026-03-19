//
//  Injected.swift
//  WatchCheerLot Watch App
//
//  Created by 이현주 on 3/19/26.
//

import Foundation

/// DI Container에서 의존성을 주입하는 PropertyWrapper
@propertyWrapper
struct Injected<T> {

  private let type: T.Type
  private let container: DIContainer

  var wrappedValue: T {
    container.resolve(type)
  }

  /// 기본 Container 사용
  init(_ type: T.Type) {
    self.type = type
    self.container = DIContainer.shared
  }

  /// 지정 Container 사용 (테스트용)
  init(_ type: T.Type, container: DIContainer) {
    self.type = type
    self.container = container
  }
}
