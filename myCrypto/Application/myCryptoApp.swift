//
//  myCryptoApp.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 23/9/2568 BE.
//

import SwiftUI
import CoreData

@main
struct myCryptoApp: App {
    let persistenceController = PersistenceController.shared

    @AppStorage("appAppearance") private var appearance: AppAppearance = .system
    @AppStorage("appLanguage") private var language: AppLanguage = .english

    var body: some Scene {
        WindowGroup {
            RootContainer()
                .preferredColorScheme(appearance.colorScheme)
                .environment(\.locale, language.locale)
        }
    }
}
