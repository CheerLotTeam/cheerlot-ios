//
//  PlayTeamMembersUseCase.swift
//  CheerLot
//
//  Created by 이승진 on 3/18/26.
//

import Foundation

protocol PlayTeamMembersUseCase {
  /// 전체 선수 화면의 모든 재생 가능한 곡을 첫 곡부터 재생한다.
  func playAll(
    rows: [TeamMembersSongVO],
    currentTeam: TeamInfo,
    isGameDay: Bool
  )

  /// 전체 선수 화면에서 특정 row를 선택했을 때,
  /// 재생 가능한 곡 목록을 기준으로 해당 row부터 재생한다.
  func playSelected(
    row: TeamMembersSongVO,
    allRows: [TeamMembersSongVO],
    currentTeam: TeamInfo,
    isGameDay: Bool
  )
}
