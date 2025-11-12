//
//  CoreDataStack.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 23.05.2025.
//

import CoreData

public final class CoreDataStack {

    // MARK: - Singleton

    public static let shared = CoreDataStack()

    private init() {}

    // MARK: - Persistent Container

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Veritabanı yüklenemedi: \(error)")
            }
        }
        return container
    }()

    // MARK: - Context

    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save

    public func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("❌ Core Data Save Error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

