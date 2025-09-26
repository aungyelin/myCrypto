//
//  Persistence.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 23/9/2568 BE.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        // Optionally seed preview data for your Core Data model here.
        // Leaving empty to avoid referencing a non-existent template entity (e.g., Item).
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "myCrypto")
        let description = container.persistentStoreDescriptions.first
        // Enable automatic lightweight migration
        description?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
#if DEBUG
        if let entities = container.managedObjectModel.entitiesByName["FavoriteCoin"] {
            print("✅ Core Data model contains FavoriteCoin entity: \(entities)")
        } else {
            assertionFailure("❌ FavoriteCoin entity missing from Core Data model. Check .xcdatamodeld current version and contents.")
        }
#endif
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

