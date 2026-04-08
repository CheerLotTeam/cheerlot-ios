//
//  LineupAPI.swift
//  CheerLot
//
//  Created by theo on 6/2/25.
//

import Foundation
import Moya
internal import Alamofire

enum PlayerAPI {
  case getLineup(teamCode: String)
  case getPlayer(playerCode: String)
  case getAllPlayers(teamCode: String)
}

extension PlayerAPI: APITargetType {
  var baseURL: URL {
    return URL(string: API.playerURL)!
  }

  var path: String {
    switch self {
    case .getLineup(let teamCode):
      return "/team/\(teamCode)"
    case .getPlayer(let playerCode):
      return "/\(playerCode)"
    case .getAllPlayers(let teamCode):
      return "/team/\(teamCode)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .getLineup, .getPlayer, .getAllPlayers:
      return .get
    }
  }

  var task: Task {
    switch self {
    case .getLineup:
      return .requestParameters(parameters: ["role": "starter"], encoding: URLEncoding.queryString)
    case .getPlayer, .getAllPlayers:
      return .requestPlain
    }
  }
}
