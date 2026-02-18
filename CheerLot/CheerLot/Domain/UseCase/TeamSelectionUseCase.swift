//
//  TeamSelectionUseCase.swift
//  CheerLot
//
//  Created by 이현주 on 2/10/26.
//

import Foundation

protocol TeamSelectionUseCase {
    /// 현재 선택된 팀 정보를 가져옵니다.
    func getCurrentTeam() -> TeamInfo?
    
    /// 팀을 선택하여 저장합니다.
    func selectTeam(_ teamId: TeamID)
    
    /// 팀을 교체합니다.
    func changeTeam(_ teamId: TeamID)
    
    /// 선택한 팀의 여부를 확인합니다.
    func hasSelectedTeam() -> Bool
}
