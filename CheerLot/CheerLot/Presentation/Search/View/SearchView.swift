//
//  SearchView.swift
//  CheerLot
//
//  Created by 이승진 on 2/28/26.
//

import SwiftUI

/// 팀 내 선수를 검색할 수 있는 화면입니다.
struct SearchView: View {
  @Environment(AppCoordinator.self) private var coordinator

  // MARK: - Properties

  let asset: SearchAssetVO

  @State private var query: String = ""

  // TODO: 실제 멤버 데이터로 교체 예정
  @State private var allMembers: [MemberRowModel] = [
    .init(id: "1", name: "구자욱", backNumber: 5, hasSong: true),
    .init(id: "2", name: "원태인", backNumber: 18, hasSong: false),
    .init(id: "3", name: "원태인", backNumber: 18, hasSong: true),
    .init(id: "4", name: "원태인", backNumber: 18, hasSong: false),
    .init(id: "5", name: "원태인", backNumber: 18, hasSong: true),
    .init(id: "6", name: "김선수", backNumber: 23, hasSong: false),
  ]

  /// 공백 제거된 검색어
  private var trimmedQuery: String {
    query.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// 검색어 비어있는지 여부
  private var isQueryEmpty: Bool { trimmedQuery.isEmpty }

  /// 검색 결과 필터링
  private var filteredMembers: [MemberRowModel] {
    guard !isQueryEmpty else { return [] }

    return allMembers.filter {
      $0.name.localizedCaseInsensitiveContains(trimmedQuery)
        || String($0.backNumber).contains(trimmedQuery)
    }
  }

  // MARK: - Body

  var body: some View {
    Group {
      if isQueryEmpty {
        memberSearchView
      } else if filteredMembers.isEmpty {
        emptySearchView
      } else {
        searchResultView(members: filteredMembers)
      }
    }
    .toolBar_titleWithProfile(title: "검색") {
      coordinator.push(.settings)
    }
    .searchable(text: $query, prompt: "검색어를 입력해주세요")
  }
}

extension SearchView {
  /// 메인 검색 뷰
  private var memberSearchView: some View {
    VStack(alignment: .center, spacing: 32) {
      Image(.noGame)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 84)

      Text("우리 팀 선수를 검색해보세요")
        .font(.M1)
        .foregroundStyle(.gray200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  /// 검색 결과 없을 때 보여지는 뷰
  private var emptySearchView: some View {
    VStack(alignment: .center, spacing: 32) {
      Image(.noSeason)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 84)

      Text("검색 결과가 없습니다")
        .font(.M1)
        .foregroundStyle(.gray200)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  /// 검색 결과 있을 시 보여지는 뷰
  private func searchResultView(members: [MemberRowModel]) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("총 \(members.count)곡")
        .font(.M4)
        .foregroundStyle(.gray400)
        .padding(.top, 20)
        .padding(.leading, 20)

      List(members) { member in
        SearchResultCell(
          asset: asset,
          memberName: member.name,
          hasSong: member.hasSong,
          backNumber: member.backNumber
        )
        .contentShape(Rectangle())
        .onTapGesture {
          // TODO: 탭 시 재생/상세 이동 추가 예정
        }
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
      }
      .listStyle(.plain)
    }
  }
}

// TODO: - 지울 예정
struct MemberRowModel: Identifiable, Hashable {
  let id: String
  let name: String
  let backNumber: Int
  let hasSong: Bool
}
