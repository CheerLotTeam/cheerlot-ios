//
//  Injected.swift
//  WidgetCheerLot
//

import Foundation

@propertyWrapper
struct Injected<T> {

  private let type: T.Type
  private let container: WidgetDIContainer

  var wrappedValue: T {
    container.resolve(type)
  }

  /// 기본 Container 사용
  init(_ type: T.Type) {
    self.type = type
    self.container = WidgetDIContainer.shared
  }

  /// 지정 Container 사용 (테스트용)
  init(_ type: T.Type, container: WidgetDIContainer) {
    self.type = type
    self.container = container
  }
}
