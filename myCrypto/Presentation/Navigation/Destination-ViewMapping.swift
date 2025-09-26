//
//  Destination-ViewMapping.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

@ViewBuilder func view(for destination: RootDestination) -> some View {
    switch destination {
    case .welcome: WelcomeView()
    case .main: MainView()
    }
}

@ViewBuilder func view(for destination: PushDestination) -> some View {
    switch destination {
    case .details(let id): DetailsView(currencyID: id)
    }
}

@ViewBuilder func view(for destination: SheetDestination) -> some View {
    Group {
        switch destination {
        case .sheet1: EmptyView()
        case .sheet2: EmptyView()
        }
    }
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.medium, .large])
}

@ViewBuilder func view(for destination: FullScreenDestination) -> some View {
    Group {
        switch destination {
        case .profile: ProfileView()
        case .notification: NotificationsView()
        }
    }
}
