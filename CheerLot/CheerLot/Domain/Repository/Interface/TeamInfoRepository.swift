//
//  TeamInfoRepository.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import Foundation

protocol TeamInfoRepository {
    /// 해당 팀 정보를 가져옵니다.
    ///
    ///  - Parameter
    ///    - teamId : 팀코드
    func getTeamInfo(_ teamId: String) -> TeamInfo?
    
    /// 모든 팀 정보를 가져옵니다.
    func getAllTeamInfo() -> [TeamInfo]
}
