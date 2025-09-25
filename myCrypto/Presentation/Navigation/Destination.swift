//
//  Destination.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import Foundation

enum Destination: Hashable {
    case root(_ destination: RootDestination)
    case tab(_ destination: TabDestination)
    case push(_ destination: PushDestination)
    case sheet(_ destination: SheetDestination)
    case fullScreen(_ destination: FullScreenDestination)
}

enum RootDestination: Hashable {
    case welcome
    case main
}

enum TabDestination: Hashable {
    case home
    case trade
    case market
    case settings
}

enum PushDestination: Hashable {
    case details
    case notifications
}

enum SheetDestination: Hashable, Identifiable {
    case sheet1
    case sheet2
    
    var id: UUID { UUID() }
}

enum FullScreenDestination: Hashable, Identifiable {
    case fullScreen1
    case fullScreen2
    
    var id: UUID { UUID() }
}
