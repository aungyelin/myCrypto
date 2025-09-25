//
//  NavigationButton.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

public struct NavigationButton<Content: View>: View {
    let destination: Destination
    @ViewBuilder var content: () -> Content
    @Environment(Router.self) private var router

    init(
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = destination
        self.content = content
    }
    
    init(
        root destination: RootDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .root(destination)
        self.content = content
    }

    init(
        push destination: PushDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .push(destination)
        self.content = content
    }

    init(
        sheet destination: SheetDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .sheet(destination)
        self.content = content
    }

    init(
        fullScreen destination: FullScreenDestination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.destination = .fullScreen(destination)
        self.content = content
    }

    public var body: some View {
        Button(action: { router.navigate(to: destination) }) {
            content()
        }
    }
}
