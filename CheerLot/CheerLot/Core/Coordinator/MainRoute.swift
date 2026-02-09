//
//  MainRoute.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

enum MainRoute: Hashable {
    case settings
    
    // 지원
    case serviceInfo
    case makerInfo
    
    // 서비스 소개
    case termsOfService
    case privacyPolicy
    case copyright
}

extension AppCoordinator {
    
    @ViewBuilder
    func buildView(for route: MainRoute) -> some View {
//        let factory = ViewModelFactory.shared
        
        // TODO: - View 넣기
        switch route {
        case .settings:

        case .serviceInfo:
            
        case .makerInfo:
            
        case .termsOfService:
            
        case .privacyPolicy:
            
        case .copyright:
        }
    }
}
