//
//  TermsOfServiceView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 31/8/2569 BE.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        DummyScreenView(
            title: "Terms of Service",
            iconName: "doc.text.magnifyingglass",
            description: "Read about the rules, guidelines, and agreements for using our services."
        )
        .navigationTitle("Terms of Service")
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
        TermsOfServiceView()
    }
}
