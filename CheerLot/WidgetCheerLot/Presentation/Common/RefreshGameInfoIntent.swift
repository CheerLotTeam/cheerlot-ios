//
//  RefreshGameInfoIntent.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import WidgetKit
import AppIntents

struct RefreshGameInfoIntent: AppIntent {
    static var title: LocalizedStringResource = "경기 정보 새로고침"
    
    func perform() async throws -> some IntentResult {
        WidgetKind.gameInfoWidgets.forEach {
            WidgetCenter.shared.reloadTimelines(ofKind: $0)
        }
        return .result()
    }
}
