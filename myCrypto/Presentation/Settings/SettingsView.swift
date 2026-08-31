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
    
    @AppStorage("appAppearance") private var appearance: AppAppearance = .system
    @AppStorage("appLanguage") private var language: AppLanguage = .english
    
    // Helper computed properties for version info
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "N/A"
    }
    
    private var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "N/A"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TitleLabel("Settings")
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // PREFERENCES SECTION
                    SettingsSection(title: "Preferences", icon: "gearshape.fill") {
                        SettingsRowPicker(title: "Appearance", icon: "paintpalette.fill", color: .indigo, selection: $appearance)
                        Divider()
                        SettingsRowPicker(title: "Language", icon: "globe", color: .blue, selection: $language)
                    }
                    
                    // ABOUT SECTION
                    SettingsSection(title: "About", icon: "info.circle.fill") {
                        Text("myCrypto is a simple app to track cryptocurrency prices. This project is for portfolio purposes, showcasing SwiftUI and modern iOS development practices.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // DEVELOPER SECTION
                    SettingsSection(title: "Developer", icon: "person.crop.circle.fill") {
                        SettingsRowLink(title: "Website", icon: "link", color: .teal, url: "https://yelinaung.dev/", linkText: "yelinaung.dev")
                        Divider()
                        SettingsRowLink(title: "Source Code", icon: "curlybraces", color: .purple, url: "https://github.com/aungyelin/myCrypto", linkText: "GitHub")
                    }
                    
                    // SUPPORT & LEGAL SECTION
                    SettingsSection(title: "Support & Legal", icon: "questionmark.circle.fill") {
                        SettingsRowButton(title: "Help & FAQ", icon: "questionmark.bubble.fill", color: .orange) {
                            router.present(fullScreen: .helpAndFAQ)
                        }
                        Divider()
                        SettingsRowButton(title: "Privacy Policy", icon: "hand.raised.fill", color: .blue) {
                            router.present(fullScreen: .privacyPolicy)
                        }
                        Divider()
                        SettingsRowButton(title: "Terms of Service", icon: "doc.text.fill", color: .purple) {
                            router.present(fullScreen: .termsOfService)
                        }
                    }
                    
                    // APPLICATION SECTION
                    SettingsSection(title: "Application", icon: "app.badge.fill") {
                        SettingsRowInfo(title: "Version", value: appVersion)
                        Divider()
                        SettingsRowInfo(title: "Build", value: buildNumber)
                    }
                    
                    // LOGOUT / RESET
                    Button(action: {
                        viewModel.setOnboardingStatusAsUndone()
                        router.navigate(to: .root(.welcome))
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.uturn.backward.circle.fill")
                                .font(.system(size: 18))
                            Text("Go Back to Welcome")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.red.opacity(0.85))
                        )
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - Reusable Setting Components

struct SettingsSection<Content: View>: View {
    let title: LocalizedStringKey
    let icon: String
    let content: Content
    
    init(title: LocalizedStringKey, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            .padding(.leading, 8)
            
            VStack(spacing: 12) {
                content
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
            )
        }
    }
}

struct SettingsRowPicker<T: Hashable & RawRepresentable & CaseIterable>: View where T.RawValue == String, T.AllCases: RandomAccessCollection {
    let title: LocalizedStringKey
    let icon: String
    let color: Color
    @Binding var selection: T
    
    var body: some View {
        HStack(spacing: 16) {
            SettingIcon(icon: icon, color: color)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            Picker("", selection: $selection) {
                ForEach(T.allCases, id: \.self) { option in
                    Text(LocalizedStringKey(option.rawValue)).tag(option)
                }
            }
            .tint(.secondary)
            .labelsHidden()
        }
    }
}

struct SettingsRowInfo: View {
    let title: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsRowLink: View {
    let title: LocalizedStringKey
    let icon: String
    let color: Color
    let url: String
    let linkText: LocalizedStringKey
    
    var body: some View {
        HStack(spacing: 16) {
            SettingIcon(icon: icon, color: color)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
            
            Spacer()
            
            if let linkURL = URL(string: url) {
                Link(linkText, destination: linkURL)
                    .font(.system(size: 16))
                    .foregroundColor(.accentColor)
            }
        }
    }
}

struct SettingsRowButton: View {
    let title: LocalizedStringKey
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                SettingIcon(icon: icon, color: color)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct SettingIcon: View {
    let icon: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(color.opacity(0.15))
                .frame(width: 32, height: 32)
            
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
        }
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        SettingsView()
    }
}
