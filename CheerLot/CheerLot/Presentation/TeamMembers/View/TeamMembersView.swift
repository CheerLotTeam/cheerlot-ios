//
//  TeamMembersView.swift
//  CheerLot
//
//  Created by 이승진 on 2/2/26.
//

import SwiftUI

/// 전체 선수 화면입니다.
struct TeamMembersView: View {
  
  // MARK: - Properties
  private let asset: TeamMembersAssetVO
  private let team: TeamInfo

  @State private var viewModel: TeamMembersViewModel
  @Environment(AppCoordinator.self) private var coordinator
  
  // MARK: - Init
  init(team: TeamInfo,
       asset: TeamMembersAssetVO
       viewModel: TeamMembersViewModel
       ) {
    self.team = team
    self.asset = asset
    self.viewModel = viewModel
  }
  
  // MARK: - Body
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        header
        
        ForEach(viewModel.members) { member in
          TeamMembersCell(
            asset: asset,
            memberName: member.name,
            hasSong: member.hasSong,
            backNumber: member.backNumber
          )
          .contentShape(Rectangle())
          .onTapGesture {
            viewModel.didTapMember(member)
          }
        }
      }
      .padding(.horizontal, 20)
    }
  }
}

extension TeamMembersView {
  /// 상단 헤더 영역 (TeamCard + infoPlayRow)
  private var header: some View {
    VStack(alignment: .center, spacing: 12) {
        TeamCard(asset: asset, team: team)
      infoPlayRow
    }
  }
  
  /// 곡 수 + 전체 재생 버튼
  private var infoPlayRow: some View {
    HStack {
      Text("총 \(viewModel.members.count)곡")
        .font(.M4)
        .foregroundStyle(.gray400)
      
      Spacer()
      
      PlayButton(
        action: { viewModel.didTapPlayAll() },
        asset: asset
      )
    }
    .padding(.leading, 10)
  }
}
