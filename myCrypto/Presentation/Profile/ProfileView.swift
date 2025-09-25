//
//  ProfileView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("ProfileView")
            .navigationTitle("Profile")
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
        ProfileView()
    }
}
