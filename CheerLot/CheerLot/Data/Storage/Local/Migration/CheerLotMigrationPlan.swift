//
//  CheerLotMigrationPlan.swift
//  CheerLot
//
//  Created by 이현주 on 9/28/25.
//

import Foundation
import SwiftData

enum CheerLotMigrationPlan: SchemaMigrationPlan {
  static var schemas: [any VersionedSchema.Type] {
    [
      CheerLotSchemaV1.self,
      CheerLotSchemaV2.self,
      CheerLotSchemaV3.self,
    ]
  }

  static var stages: [MigrationStage] {
    [migrateV1toV2, migrateV2toV3]
  }

  static let migrateV1toV2 =
    MigrationStage.custom(
      fromVersion: CheerLotSchemaV1.self,
      toVersion: CheerLotSchemaV2.self,
      willMigrate: { context in
        // 이 시점에서는 V1 모델 기준으로 접근 가능
        // Player / CheerSong 모두 날려버리기
        try context.fetch(FetchDescriptor<CheerLotSchemaV1.Player>())
          .forEach { context.delete($0) }
        try context.fetch(FetchDescriptor<CheerLotSchemaV1.CheerSong>())
          .forEach { context.delete($0) }
        try context.save()
      },
      didMigrate: { context in
        // 이 시점에서는 V2 모델 기준
        // Team만 유지되고, 선수는 API를 통해 새로 불러와 저장
        let teams = try context.fetch(FetchDescriptor<CheerLotSchemaV2.Team>())
        for team in teams {
          team.lineupVersion = -1
          team.playersVersion = -1
          team.hasGame = true
          team.isSeasonActive = true
        }
        try context.save()
      }
    )

  static let migrateV2toV3 = MigrationStage.custom(
    fromVersion: CheerLotSchemaV2.self,
    toVersion: CheerLotSchemaV3.self,
    willMigrate: { context in
      // Team, Player, CheerSong 전부 삭제
      try context.fetch(FetchDescriptor<CheerLotSchemaV2.Team>())
        .forEach { context.delete($0) }
      try context.fetch(FetchDescriptor<CheerLotSchemaV2.Player>())
        .forEach { context.delete($0) }
      try context.fetch(FetchDescriptor<CheerLotSchemaV2.CheerSong>())
        .forEach { context.delete($0) }
      try context.save()
    },
    didMigrate: { context in
      // V3 기준으로 Team 새로 insert (신규 설치와 동일한 흐름)
      for code in TeamDataSource.TeamCode.allCases {
        let team = CheerLotSchemaV3.Team(
          teamId: code.rawValue,
          hasTodayGame: false,
          isSeasonEnded: false
        )
        context.insert(team)
      }
      try context.save()
    }
  )
}
