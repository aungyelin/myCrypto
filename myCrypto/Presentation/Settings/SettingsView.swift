//
//  SettingsView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Router.self) private var router
    private let viewModel = SettingViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleLabel("Settings")
            
            Spacer()
            
            Button(action: {
                viewModel.setOnboardingStatusAsUndone()
                router.navigate(to: .root(.welcome))
            }) {
                HStack(spacing: 12) {
                    Text("Go Back to Welcome")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.accent)
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        SettingsView()
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        MainView()
    }
}
