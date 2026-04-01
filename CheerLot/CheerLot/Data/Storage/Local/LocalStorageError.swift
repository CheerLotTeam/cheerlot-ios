//
//  LocalStorageError.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation

enum LocalStorageError: LocalizedError {
  case fetchError
  case notFound
  case invalidData
  case saveFailed
  case dataAlreadyExist

  var errorDescription: String? {
    switch self {
    case .fetchError:
      return "데이터를 불러오는 데 실패했습니다."
    case .notFound:
      return "데이터를 찾을 수 없습니다."
    case .invalidData:
      return "잘못된 데이터입니다."
    case .saveFailed:
      return "저장에 실패했습니다."
    case .dataAlreadyExist:
      return "이미 존재하는 데이터입니다."
    }
  }
}
