//
//  LocalStorage.swift
//  CheerLot
//
//  Created by 이현주 on 2/10/26.
//

import Foundation
import SwiftData

final class LocalStorage {
    let modelContainer = {
        let schema = Schema([
            Team.self,
            Player.self,
            CheerSong.self,
        ])
        
        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: false
        )
        
        do {
            let container = try ModelContainer(
                for: schema,
                migrationPlan: CheerLotMigrationPlan.self,
                configurations: configuration
            )
            
            return container
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}

// TODO: - DataMigrationService 위치 찾기
