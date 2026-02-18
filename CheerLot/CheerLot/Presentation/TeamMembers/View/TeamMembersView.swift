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

  // MARK: - Init
  init(team: TeamInfo,
       asset: TeamMembersAssetVO) {
    self.team = team
    self.asset = asset
  }

  // MARK: - Body
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        header

        ForEach(mockMembers) { member in
          TeamMembersCell(
            asset: asset,
            memberName: member.name,
            hasSong: member.hasSong,
            backNumber: member.backNumber
          )
          .contentShape(Rectangle())
          .onTapGesture {
            print("\(member.name) 눌림")
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
      Text("총 \(mockMembers.count)곡")
        .font(.M4)
        .foregroundStyle(.gray400)

      Spacer()

      PlayButton(
        action: { print("전체 재생") },
        asset: asset
      )
    }
    .padding(.leading, 10)
  }
}

// TODO: 이후 지울 예정
private struct Member: Identifiable {
  let id = UUID()
  let name: String
  let backNumber: Int
  let hasSong: Bool
}

private let mockMembers: [Member] = [
  Member(name: "김선수", backNumber: 23, hasSong: true),
  Member(name: "이선수", backNumber: 7, hasSong: false),
  Member(name: "박선수", backNumber: 10, hasSong: true),
  Member(name: "김선수", backNumber: 23, hasSong: true),
  Member(name: "이선수", backNumber: 7, hasSong: false),
  Member(name: "박선수", backNumber: 10, hasSong: true),
  Member(name: "김선수", backNumber: 23, hasSong: true),
  Member(name: "이선수", backNumber: 7, hasSong: false),
  Member(name: "박선수", backNumber: 10, hasSong: true),
  Member(name: "김선수", backNumber: 23, hasSong: true),
  Member(name: "이선수", backNumber: 7, hasSong: false),
  Member(name: "박선수", backNumber: 10, hasSong: true),
  Member(name: "김선수", backNumber: 23, hasSong: true),
  Member(name: "이선수", backNumber: 7, hasSong: false),
  Member(name: "박선수", backNumber: 10, hasSong: true),
  Member(name: "김선수", backNumber: 23, hasSong: true),
  Member(name: "이선수", backNumber: 7, hasSong: false),
  Member(name: "박선수", backNumber: 10, hasSong: true),
  Member(name: "김선수", backNumber: 23, hasSong: true),
  Member(name: "이선수", backNumber: 7, hasSong: false),
  Member(name: "박선수", backNumber: 10, hasSong: true)
]

#Preview {
  TeamMembersView(
    team: TeamDataSource.toEntity(.kia),
    asset: TeamMembersAssetVO(
        base: TeamAssetVO(TeamDataSource.toEntity(.kia).id)
    )
  )
}
