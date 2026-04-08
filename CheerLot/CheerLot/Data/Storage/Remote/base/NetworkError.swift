//
//  NetworkError.swift
//  CheerLot
//
//  Created by 이현주 on 9/23/25.
//

import Foundation
import Moya

enum APIType {
  case player(PlayerAPIType)
  case team(TeamAPIType)

  enum PlayerAPIType {
    case lineup
    case playerDetail
    case allPlayers
  }

  enum TeamAPIType {
    case todayGameInfo
    case versions
    case gamesInfo
  }
}

enum NetworkError: Error {
  case decodingError(Error)
  case moyaError(MoyaError, api: APIType)

  /// 디버깅/로그용
  var localizedDescription: String {
    switch self {
    case .decodingError(let error):
      return "데이터 파싱 실패: \(error.localizedDescription)"
    case .moyaError(let error, _):
      return "네트워크 요청 실패: \(error.localizedDescription)"
    }
  }

  /// 사용자 노출용 메시지
  var userMessage: String {
    switch self {
    case .decodingError:
      return "데이터 형식이 올바르지 않습니다."

    case .moyaError(let moyaError, _):
      switch moyaError {
      case .underlying(let nsError as NSError, _):
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
          return "인터넷 연결을 확인해주세요."
        case NSURLErrorTimedOut:
          return "요청 시간이 초과되었습니다."
        default:
          return "네트워크 연결 상태 확인 후 다시 시도해 주세요"
        }

      case .statusCode(let response):
        // 서버 에러 메시지 파싱
        if let serverMessage = parseServerErrorMessage(from: response.data) {
          return serverMessage
        }

        // 파싱 실패 시 상태 코드별 기본 메시지
        switch response.statusCode {
        case 400...499:
          return "요청을 처리할 수 없습니다."
        case 500...599:
          return "서버에 일시적인 문제가 발생했습니다."
        default:
          return "요청을 처리할 수 없습니다. (상태코드: \(response.statusCode))"
        }

      default:
        return "네트워크 요청 중 오류가 발생했습니다."
      }
    }
  }

  /// 서버 에러 응답에서 메시지 추출
  private func parseServerErrorMessage(from data: Data) -> String? {
    guard let errorResponse = try? JSONDecoder().decode(ServerErrorResponseDTO.self, from: data),
      !errorResponse.message.isEmpty
    else {
      return nil
    }
    return errorResponse.message
  }
}
