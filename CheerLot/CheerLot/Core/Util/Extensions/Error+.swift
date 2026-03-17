//
//  Error+.swift
//  CheerLot
//
//  Created by 이현주 on 3/17/26.
//

import Foundation

extension Error {
  var userMessage: String {
    switch self {
    case let networkError as NetworkError:
      return networkError.userMessage

    case let localError as LocalStorageError:
      return localError.errorDescription ?? "알 수 없는 오류가 발생했습니다"

    default:
      return "일시적인 오류가 발생했습니다"
    }
  }
}
