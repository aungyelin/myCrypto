//
//  MainView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI
import FactoryKit

struct MainView: View {
    @Environment(Router.self) private var router
    private let viewModel = MainViewModel()
    
    var body: some View {
        @Bindable var router = router
        
        TabView(selection: $router.selectedTab) {
            NavigationContainer(parentRouter: router, tab: .home) {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(TabDestination.home)
            
            NavigationContainer(parentRouter: router, tab: .trade) {
                TradeView()
            }
            .tabItem { Label("Trade", systemImage: "arrow.left.arrow.right") }
            .tag(TabDestination.trade)
            
            NavigationContainer(parentRouter: router, tab: .market) {
                MarketView()
            }
            .tabItem { Label("Market", systemImage: "chart.pie.fill") }
            .tag(TabDestination.market)
            
            NavigationContainer(parentRouter: router, tab: .settings) {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
            .tag(TabDestination.settings)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.markOnboardingCompleted()
        }
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        MainView()
    }
}
