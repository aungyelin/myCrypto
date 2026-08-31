//
//  MarketView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct MarketView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TitleLabel("Market")
            
            DummyScreenView(
                title: "Market Insights",
                iconName: "chart.line.uptrend.xyaxis",
                description: "Deep dive into market trends, advanced charts, and global statistics."
            )
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        MarketView()
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        MainView()
    }
}
