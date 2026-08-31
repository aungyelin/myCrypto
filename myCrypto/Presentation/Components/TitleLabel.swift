//
//  TitleLabel.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import SwiftUI

struct TitleLabel: View {
    let text: LocalizedStringKey

    init(_ text: LocalizedStringKey) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(.largeTitle, design: .default))
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .accessibilityAddTraits(.isHeader)
            .padding(.horizontal, 0)
    }
}
