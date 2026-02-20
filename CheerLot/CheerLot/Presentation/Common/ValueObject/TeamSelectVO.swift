//
//  TeamSelectVO.swift
//  CheerLot
//
//  Created by 이현주 on 2/12/26.
//

import Foundation

struct TeamSelectVO: Identifiable {
    let id: TeamID
    let englishFullName: String
    let longName: String
    let asset: TeamAssetVO
}

extension TeamSelectVO {
    // Entity -> VO 변환
    init(team: TeamInfo) {
        self.id = team.id
        self.englishFullName = team.englishFullName.replacingOccurrences(of: " ", with: "\n")
        self.longName = team.longName
        self.asset = .init(team.id)
    }
}
