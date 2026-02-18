//
//  TeamInfo.swift
//  CheerLot
//
//  Created by 이현주 on 1/26/26.
//

import Foundation

/// Team 기본 정보
struct TeamInfo: Identifiable, Hashable, Equatable {
    let id: TeamID
    let shortName: String
    let longName: String
    let englishFullName: String
    let slogan: String
    
    init(id: TeamID, shortName: String, longName: String, englishFullName: String, slogan: String) {
        self.id = id
        self.shortName = shortName
        self.longName = longName
        self.englishFullName = englishFullName
        self.slogan = slogan
    }
}

struct TeamID: Hashable, Codable {
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
}

extension TeamID: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self.init(value)
    }
}
