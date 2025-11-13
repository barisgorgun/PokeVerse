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
    public let container: NSPersistentContainer

    private init() {
        // 🔹 1. Framework bundle'ını bul
        let bundle = Bundle(for: FavoritePokemon.self)

        // 🔹 2. Model dosyasını yükle (.momd uzantılı derlenmiş model)
        guard let modelURL = bundle.url(forResource: "CoreDataModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("❌ CoreData model could not be loaded from Core framework bundle.")
        }

        // 🔹 3. Container'ı oluştur
        container = NSPersistentContainer(name: "CoreDataModel", managedObjectModel: model)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Persistent store load error: \(error)")
            }
        }
    }

    // MARK: - Context

    public var context: NSManagedObjectContext {
        return container.viewContext
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

