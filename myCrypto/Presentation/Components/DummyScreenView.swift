//
//  DummyScreenView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 25/9/2568 BE.
//

import SwiftUI

struct DummyScreenView: View {
    let title: String
    let iconName: String
    let description: String
    
    var body: some View {
        VStack(spacing: 28) {
            ZStack {
                // Soft background glow/circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.accentColor.opacity(0.15), Color.accentColor.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                
                // Floating icon
                Image(systemName: iconName)
                    .font(.system(size: 60, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(6)
            }
            
            // Coming soon pill
            Text("Coming Soon")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(Color.accentColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
                .background(
                    Capsule()
                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1.5)
                        .background(Capsule().fill(Color.accentColor.opacity(0.05)))
                )
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    DummyScreenView(
        title: "Profile",
        iconName: "person.crop.circle",
        description: "We are building an awesome profile experience for you to manage your account."
    )
}
