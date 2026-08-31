//
//  TradeView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct TradeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TitleLabel("Trade")
            
            DummyScreenView(
                title: "Trade & Swap",
                iconName: "arrow.left.arrow.right.circle",
                description: "Instantly buy, sell, or swap cryptocurrencies with the lowest fees."
            )
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        TradeView()
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        MainView()
    }
}
