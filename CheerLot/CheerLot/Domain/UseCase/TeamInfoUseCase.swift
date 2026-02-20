//
//  TeamInfoUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

import Foundation

protocol TeamInfoUseCase {
    /// 특정 팀 기본 정보를 조회한다
    func getTeamInfo(_ teamId: TeamID) -> TeamInfo?
    
    /// 모든 팀의 기본 정보를 조회한다
    func getAllTeamsInfo() -> [TeamInfo]
}
