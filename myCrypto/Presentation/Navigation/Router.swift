//
//  Router.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import Foundation
import SwiftUI

@Observable
class Router {
    
    let id = UUID()
    let level: Int
    
    /// Current root view
    var rootView: RootDestination
    
    /// Defines the tab to select
    var selectedTab: TabDestination?
    
    /// Specifies which tab the router was build for
    let identifierTab: TabDestination?
    
    /// Values presented in the navigation stack
    var navigationStackPath: [PushDestination] = []
    
    /// Current presented sheet
    var presentingSheet: SheetDestination?
    
    /// Current presented full screen
    var presentingFullScreen: FullScreenDestination?
    
    /// Reference to the parent router to form a hierarchy
    /// Router levels increase for the children
    weak var parent: Router?
    
    /// A way to track which router is visible/active
    /// Used for deep link resolution
    private(set) var isActive: Bool = false
    
    
    init(level: Int, root: RootDestination, identifierTab: TabDestination?) {
        self.level = level
        self.rootView = root
        self.identifierTab = identifierTab
        self.parent = nil
    }
    
    private func resetContent() {
        navigationStackPath = []
        presentingSheet = nil
        presentingFullScreen = nil
    }
    
}

// MARK: - Router Management

extension Router {
    
    func childRouter(for tab: TabDestination? = nil) -> Router {
        let router = Router(level: level + 1, root: rootView, identifierTab: tab ?? identifierTab)
        router.parent = self
        return router
    }
    
    func setActive() {
        parent?.resignActive()
        isActive = true
    }
    
    func resignActive() {
        isActive = false
        parent?.setActive()
    }
    
    static func previewRouter() -> Router {
        Router(level: 0, root: .welcome, identifierTab: nil)
    }
    
}

// MARK: - Navigation

extension Router {
    
    func navigate(to destination: Destination) {
        switch destination {
        case let .root(root): navigate(root: root)
        case let .tab(tab): select(tab: tab)
        case let .push(destination): push(destination)
        case let .sheet(destination): present(sheet: destination)
        case let .fullScreen(destination): present(fullScreen: destination)
        }
    }
    
    func navigate(root: RootDestination) {
        if let parent {
            parent.navigate(root: root)
        } else {
            rootView = root
            resetContent()
        }
    }
    
    func select(tab destination: TabDestination) {
        if level == 0 {
            selectedTab = destination
        } else {
            parent?.select(tab: destination)
            resetContent()
        }
    }
    
    func push(_ destination: PushDestination) {
        navigationStackPath.append(destination)
    }
    
    func present(sheet destination: SheetDestination) {
        presentingSheet = destination
    }
    
    func present(fullScreen destination: FullScreenDestination) {
        presentingFullScreen = destination
    }
    
}
