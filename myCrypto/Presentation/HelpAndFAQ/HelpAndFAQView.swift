//
//  HelpAndFAQView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 31/8/2569 BE.
//

import SwiftUI

struct HelpAndFAQView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        DummyScreenView(
            title: "Help & FAQ",
            iconName: "questionmark.bubble.fill",
            description: "Find answers to your questions and get support from our team."
        )
        .navigationTitle("Help & FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                }
                .tint(.accentColor)
                .accessibilityLabel("Close")
            }
        }
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        HelpAndFAQView()
    }
}
