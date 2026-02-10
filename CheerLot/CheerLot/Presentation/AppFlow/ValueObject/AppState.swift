//
//  AppState.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

enum AppState: Equatable {
    case splash
    case onboarding
    case main(team: TeamInfo)
}
