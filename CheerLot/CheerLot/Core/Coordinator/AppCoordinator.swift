//
//  AppCoordinator.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import SwiftUI

@MainActor
@Observable
final class AppCoordinator: ObservableObject {
    var paths: [MainRoute] = []
    var modal: ModalRoute?
    
    init() {}
    
    // MARK: - Navigation (Push/Pop)
    func push(_ route: MainRoute) {
        guard paths.last != route else { return }
        paths.append(route)
    }
    
    func pop() {
        guard !paths.isEmpty else { return }
        paths.removeLast()
    }
    
    func popToRoot() {
        paths.removeAll()
    }
    
    // MARK: - Modal (Sheet + FullScreen)
    func presentModal(_ route: ModalRoute) {
        modal = route
    }
    
    func dismissModal() {
        modal = nil
    }
}
