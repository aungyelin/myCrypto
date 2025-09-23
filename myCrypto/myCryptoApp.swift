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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
