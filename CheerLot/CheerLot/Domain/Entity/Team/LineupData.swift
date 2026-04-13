//
//  LineupData.swift
//  CheerLot
//
//  Created by 이현주 on 3/15/26.
//

import Foundation

struct LineupData {
  let gameInfo: TeamGameInfo
  let lineupPlayers: [PlayerInfo]
  let opponentTeamId: TeamID?
  let recentGameInfo: TeamGameInfo? // lineupUpdatedToday=false일 때, teamData.gameInfo (최근 완료된 경기 정보). showLineup=true 상태에서 사용.
}
