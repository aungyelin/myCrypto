//
//  NotificationsView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("NotificationsView")
            .navigationTitle("Notifications")
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
        NotificationsView()
    }
}
