//
//  PrivacyPolicyView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 31/8/2569 BE.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        DummyScreenView(
            title: "Privacy Policy",
            iconName: "lock.shield.fill",
            description: "Learn how we protect your data and privacy with industry standard security."
        )
        .navigationTitle("Privacy Policy")
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
        PrivacyPolicyView()
    }
}
