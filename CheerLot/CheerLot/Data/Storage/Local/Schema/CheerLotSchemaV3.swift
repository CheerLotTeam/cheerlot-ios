//
//  CheerLotSchemaV3.swift
//  CheerLot
//
//  Created by 이현주 on 2/18/26.
//

import Foundation
import SwiftData

enum CheerLotSchemaV3: VersionedSchema {
  static var models: [any PersistentModel.Type] {
    [Team.self, Player.self, CheerSong.self]
  }

  static var versionIdentifier = Schema.Version(3, 0, 0)

  @Model
  final class Team {
    @Attribute(.unique) var teamId: String
    var hasTodayGame: Bool
    var opponentTeamId: String?
    var starterPitcherName: String?
    var lastGameDate: String?
    var isSeasonEnded: Bool
//    var lineupVersion: Int = -1
//    var playersVersion: Int = -1

    @Relationship(deleteRule: .cascade, inverse: \Player.team) var teamMemberList: [Player]?

    init(
      teamId: String,
      hasTodayGame: Bool = false,
      opponentTeamId: String? = nil,
      starterPitcherName: String? = nil,
      lastGameDate: String? = nil,
      isSeasonEnded: Bool = false,
      teamMemberList: [Player]? = nil
    ) {
      self.teamId = teamId
      self.hasTodayGame = hasTodayGame
      self.opponentTeamId = opponentTeamId
      self.starterPitcherName = starterPitcherName
      self.lastGameDate = lastGameDate
      self.isSeasonEnded = isSeasonEnded
      self.teamMemberList = teamMemberList
    }
  }

  @Model
  final class Player {
    @Attribute(.unique, originalName: "themeRaw") var playerId: String
    var name: String
    var backNumber: Int
    var position: String
    var batThrow: String
    var battingOrder: Int?
    var isStarter: Bool
      
    @Relationship(deleteRule: .cascade, inverse: \CheerSong.player) var cheerSongList: [CheerSong]?
    @Relationship var team: Team?

    init(
      playerId: String,
      name: String,
      backNumber: Int,
      position: String,
      batThrow: String,
      battingOrder: Int? = nil,
      isStarter: Bool,
      team: Team? = nil,
      cheerSongList: [CheerSong]? = nil,
    ) {
      self.playerId = playerId
      self.name = name
      self.backNumber = backNumber
      self.position = position
      self.batThrow = batThrow
      self.battingOrder = battingOrder
      self.isStarter = isStarter
      self.team = team
      self.cheerSongList = cheerSongList
    }
  }

  @Model
  final class CheerSong {
    @Attribute(.unique) var cheerSongId: String
    var title: String
    var lyrics: String
    var audioUrl: String
      
    @Relationship var player: Player?

    init(
      title: String,
      lyrics: String,
      audioUrl: String,
      player: Player? = nil
    ) {
      self.cheerSongId = "\(player?.playerId ?? "unknown")_\(title)"
      self.title = title
      self.lyrics = lyrics
      self.audioUrl = audioUrl
      self.player = player
    }
  }
}
