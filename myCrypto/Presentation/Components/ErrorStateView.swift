//
//  ErrorStateView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 31/8/2569 BE.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text("Oops, something went wrong!")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retryAction) {
                Text("Tap to Retry")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
    }
}
