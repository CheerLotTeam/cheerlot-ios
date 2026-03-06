//
//  AudioAPI.swift
//  CheerLot
//
//  Created by 이현주 on 3/3/26.
//

import Foundation
import Moya

enum AudioAPI {
  case streamAudio(fileName: String)
}

extension AudioAPI: TargetType {
  var baseURL: URL {
    URL(string: Config.streamAudioURL)!
  }

  var path: String {
    switch self {
    case .streamAudio(let fileName):
      return "/\(fileName)"
    }
  }

  var method: Moya.Method {
    .get
  }

  var task: Task {
    .requestPlain
  }

  var headers: [String: String]? {
    [
      "Accept": "audio/mpeg",
      "Range": "bytes=0-",  // Range Request 지원 (스트리밍 최적화)
    ]
  }
}
