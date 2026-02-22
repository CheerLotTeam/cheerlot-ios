//
//  TeamMembersViewModel.swift
//  CheerLot
//
//  Created by 이승진 on 2/20/26.
//

import Foundation

final class TeamMembersViewModel {

  private let audioPlayer: AudioPlaybackService

  // 지금은 mockMembers를 VM이 소유 (나중에 UseCase로 교체)
  let members: [Member]

  init(
    audioPlayer: AudioPlaybackService,
    members: [Member] = TeamMembersViewModel.mockMembers
  ) {
    self.audioPlayer = audioPlayer
    self.members = members
  }

  func didTapMember(_ member: Member) {
    guard member.hasSong else { return }

    /// 테스트
    let song = CheerSongInfo(
      id: 1,
      playerId: PlayerID("박찬호"),
      title: "기본 응원가",
      lyrics: "치고 달려라\n멀리 높이 더 빨리\n뜨거운 열정을 담아",
      audioURL: "ht1.mp3"
    )

    audioPlayer.play(song)
  }

  func didTapPlayAll() {
    // TODO: 전체 재생 로직
  }
}

extension TeamMembersViewModel {
  static let mockMembers: [Member] = [
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
    Member(name: "박선수", backNumber: 10, hasSong: true),
  ]
}

struct Member: Identifiable {
  let id = UUID()
  let name: String
  let backNumber: Int
  let hasSong: Bool

  /// 임시 mock용 PlayerID
  var playerIdMock: PlayerID {
    PlayerID("\(backNumber)")
  }
}
