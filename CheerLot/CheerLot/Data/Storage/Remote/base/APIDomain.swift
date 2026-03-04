//
//  APIDomain.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

public struct API {
  public static let baseURL = Config.apiURL
  public static let playerURL = "\(baseURL)/players"
  public static let teamURL = "\(baseURL)/teams"
}
