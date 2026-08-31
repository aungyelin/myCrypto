//
//  SettingsModels.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 31/8/2569 BE.
//

import SwiftUI

enum AppAppearance: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case chinese = "中文"
    case japanese = "日本語"
    
    var locale: Locale {
        switch self {
        case .english: return Locale(identifier: "en")
        case .chinese: return Locale(identifier: "zh-Hans")
        case .japanese: return Locale(identifier: "ja")
        }
    }
}
