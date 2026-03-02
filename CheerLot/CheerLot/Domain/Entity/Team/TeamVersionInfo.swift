//
//  TeamVersionInfo.swift
//  CheerLot
//
//  Created by 이현주 on 3/2/26.
//

import Foundation

/// Team 라인업, 전체 선수 버전 정보
struct TeamVersionInfo: Identifiable, Hashable, Equatable {
    let id: TeamID
    let lineupVersion: Int
    let playersVersion: Int
    
    init(id: TeamID, lineupVersion: Int, playersVersion: Int) {
        self.id = id
        self.lineupVersion = lineupVersion
        self.playersVersion = playersVersion
    }
}
