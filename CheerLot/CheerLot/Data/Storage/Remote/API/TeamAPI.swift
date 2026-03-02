//
//  TeamAPI.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation
import Moya

enum TeamAPI {
  case getTeamGameInfo(teamCode: String)
  case getTeamVersions(teamCode: String)
}

extension TeamAPI: APITargetType {
    var baseURL: URL {
        return URL(string: API.teamURL)!
    }
    
  var path: String {
    switch self {
    case .getTeamGameInfo(let teamCode):
      return "/\(teamCode)"
    case .getTeamVersions(let teamCode):
      return "/\(teamCode)/version"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getTeamGameInfo, .getTeamVersions:
      return .get
    }
  }

  var task: Task {
    switch self {
    case .getTeamGameInfo, .getTeamVersions:
      return .requestPlain
    }
  }
}
