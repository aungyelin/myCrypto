//
//  WelcomeView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI
import UIKit

struct WelcomeView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                
                HeroIllustration()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                Text("Your personal cryto wallet")
                    .font(.system(size: 38, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Its secure and support near about hundred cryto currencies")
                    .font(.system(size: 17))
                    .opacity(0.6)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                NavigationButton(root: .main) {
                    HStack(spacing: 12) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.cyan, .accent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 24)
        }
    }
}

private struct HeroIllustration: View {
    var body: some View {
        Group {
            if let uiImage = UIImage(named: "phone") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .fill(LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .cyan.opacity(0.5), radius: 24, x: 0, y: 12)
                    Image(systemName: "creditcard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                        .opacity(0.9)
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
        .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 16)
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        WelcomeView()
    }
}

