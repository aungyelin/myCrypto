//
//  HomeView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header
            Spacer()
            NavigationButton(push: .details) {
                HStack(spacing: 12) {
                    Text("Go to Details")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(.accent))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
    
    private var header: some View {
        HStack {
            NavigationButton(fullScreen: .notification) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.accent.opacity(0.1))
                    Image("profile")
                }
                .frame(width: 40, height: 40)
            }
            
            Spacer()
            
            NavigationButton(fullScreen: .notification) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.accent.opacity(0.1))
                    Image(systemName: "bell")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 20, weight: .medium))
                }
                .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        HomeView()
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        MainView()
    }
}

