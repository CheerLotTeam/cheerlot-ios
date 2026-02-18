//
//  ModalRoute.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

enum PresentationStyle {
    case sheet
    case fullScreen
}

enum ModalRoute: Identifiable {
    // TODO: - 각 case 마다 넘겨주는 값(파라미터) 재설정
    // Sheet 스타일
    case cheerSongList
    case lineupChange
    case teamChange
    case inquiry
    case servicePage
    
    // FullScreen 스타일
    case lineupPlayback
    case basePlayback
    
    var id: String {
      String(describing: self)
    }
    
    var presentationStyle: PresentationStyle {
        switch self {
        case .cheerSongList, .lineupChange, .teamChange, .inquiry, .servicePage:
            return .sheet
        case .lineupPlayback, .basePlayback:
            return .fullScreen
        }
    }
}

extension AppCoordinator {
    @ViewBuilder
    func buildModalView(for route: ModalRoute) -> some View {
//        let factory = ViewModelFactory.shared
        
        // TODO: - View 넣기
        switch route {
        case let .cheerSongList:
            Color.clear
        case let .lineupChange:
            Color.clear
        case let .teamChange:
            Color.clear
        case let .inquiry:
            Color.clear
        case let .servicePage:
            Color.clear
        case let .lineupPlayback:
            Color.clear
        case let .basePlayback:
            Color.clear
        }
    }
}
