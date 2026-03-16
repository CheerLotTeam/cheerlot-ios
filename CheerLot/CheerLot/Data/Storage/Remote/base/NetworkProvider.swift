//
//  NetworkProvider.swift
//  CheerLot
//
//  Created by 이현주 on 3/4/26.
//

import Foundation
import Moya

final class NetworkProvider {
  static let shared = NetworkProvider()

  private init() {}

  func createProvider<T: TargetType>() -> MoyaProvider<T> {
    #if DEBUG
    let plugins: [PluginType] = [
      NetworkLoggerPlugin(
        configuration: .init(
          logOptions: .verbose  // 상세 로그
        ))
    ]
    #else
    let plugins: [PluginType] = []
    #endif

    return MoyaProvider<T>(plugins: plugins)
  }
}
