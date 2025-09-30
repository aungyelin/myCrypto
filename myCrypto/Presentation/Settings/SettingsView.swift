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
    
    // Helper computed properties for version info
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "N/A"
    }
    
    private var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "N/A"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TitleLabel("Settings")
            
            VStack(alignment: .leading, spacing: 16) {
                // ABOUT SECTION
                GroupBox(label: Label("About", systemImage: "info.circle")) {
                    Text("myCrypto is a simple app to track cryptocurrency prices. This project is for portfolio purposes, showcasing SwiftUI and modern iOS development practices.")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // DEVELOPER SECTION
                GroupBox(label: Label("Developer", systemImage: "person.circle")) {
                    HStack {
                        Text("Website")
                        Spacer()
                        if let url = URL(string: "https://yelinaung.dev/") {
                            Link("yelinaung.dev", destination: url)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // APPLICATION SECTION
                GroupBox(label: Label("Application", systemImage: "app.badge")) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text(appVersion)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                        HStack {
                            Text("Build")
                            Spacer()
                            Text(buildNumber)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.setOnboardingStatusAsUndone()
                router.navigate(to: .root(.welcome))
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.uturn.backward.circle")
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
