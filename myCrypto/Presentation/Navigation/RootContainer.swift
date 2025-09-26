//
//  RootContainer.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI
import FactoryKit

struct RootContainer: View {
    @State var router: Router
    
    init(viewModel: RootViewModel = RootViewModel()) {
        _router = State(initialValue: Router(level: 0, root: viewModel.isOnboardingDone() ? .main : .welcome, identifierTab: nil))
    }
    
    var body: some View {
        InnerContainer(router: router) {
            view(for: router.rootView)
        }
        .environment(router)
        .onAppear { router.setActive() }
        .onDisappear(perform: router.resignActive)
    }
}

private struct InnerContainer<Content: View>: View {
    @Bindable var router: Router
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .sheet(item: $router.presentingSheet) { sheet in
                navigationView(for: sheet, from: router)
            }
            .fullScreenCover(item: $router.presentingFullScreen) { fullScreen in
                navigationView(for: fullScreen, from: router)
            }
    }
    
    @ViewBuilder func navigationView(for destination: SheetDestination, from router: Router) -> some View {
        NavigationContainer(parentRouter: router) { view(for: destination) }
    }
    
    
    @ViewBuilder func navigationView(for destination: FullScreenDestination, from router: Router) -> some View {
        NavigationContainer(parentRouter: router) { view(for: destination) }
    }
}
