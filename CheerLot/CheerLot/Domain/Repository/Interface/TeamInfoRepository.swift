//
//  TeamInfoRepository.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import Foundation

protocol TeamInfoRepository {
  /// 특정 팀 기본 정보 조회
  func fetchTeamInfo(_ teamId: TeamID) throws -> TeamInfo

  /// 모든 팀 기본 정보 조회
  func fetchAllTeamInfo() -> [TeamInfo]
}
