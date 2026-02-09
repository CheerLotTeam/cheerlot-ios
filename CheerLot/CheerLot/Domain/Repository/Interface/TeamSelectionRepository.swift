//
//  TeamSelectionRepository.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation

protocol TeamSelectionRepository {
    /// 현재 선택된 팀 조회
    func fetchCurrentTeam() throws -> TeamInfo
    
    /// 팀 선택
    func updateSelectedTeam(_ team: TeamInfo) async throws
    
    /// 팀 선택 여부 조회
    func fetchHasSelectedTeam() -> Bool
    
    /// 팀 선택 초기화
    func deleteSelectedTeam() async throws
}
