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
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
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
