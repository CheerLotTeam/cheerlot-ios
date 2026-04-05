//
//  TeamAPI.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation
import Moya

enum TeamAPI {
  case getTeamTodayGameInfo(teamCode: String)
  case getTeamVersions(teamCode: String)
  case getTeamGamesInfo(teamCode: String)
}

extension TeamAPI: APITargetType {
  var baseURL: URL {
    return URL(string: API.teamURL)!
  }

  var path: String {
    switch self {
    case .getTeamTodayGameInfo(let teamCode):
      return "/\(teamCode)"
    case .getTeamVersions(let teamCode):
      return "/\(teamCode)/version"
    case .getTeamGamesInfo(let teamCode):
      return "/\(teamCode)/games"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getTeamTodayGameInfo, .getTeamVersions, .getTeamGamesInfo:
      return .get
    }
  }

  var task: Task {
    switch self {
    case .getTeamTodayGameInfo, .getTeamVersions, .getTeamGamesInfo:
      return .requestPlain
    }
  }
}
