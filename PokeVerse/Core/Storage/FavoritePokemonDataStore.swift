//
//  FavoritePokemonDataStore.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 23.05.2025.
//

import Foundation
import CoreData
import UIKit


protocol FavoritePokemonDataStoreProtocol {
    func saveFavorite(id: String, name: String, url: String, image: UIImage) throws
    func removeFavorite(with id: String) throws
    func isFavorite(id: String) -> Bool
    func getAllFavorites() -> [FavoritePokemon]
}

final class FavoritePokemonDataStore: FavoritePokemonDataStoreProtocol {

    // MARK: - Dependencies

    private let context: NSManagedObjectContext

    // MARK: - Init

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // MARK: - Public Methods

    func saveFavorite(
        id: String,
        name: String,
        url: String,
        image: UIImage
    ) throws {
        if  isFavorite(id: id) {
            throw CoreDataError.duplicateEntry
        }

        guard !id.isEmpty, !name.isEmpty else {
            throw CoreDataError.invalidData
        }

        guard let imageData = image.pngData() else {
            throw CoreDataError.invalidData
        }

        let favorite = FavoritePokemon(context: context)
        favorite.id = id
        favorite.name = name
        favorite.url = url
        favorite.image = imageData

        do {
            try context.save()
        } catch {
            throw CoreDataError.saveError(error)
        }
    }

    func isFavorite(id: String) -> Bool {
        let request: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }

    func removeFavorite(with id: String) throws {
        let request: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            try context.save()
        } catch {
            throw CoreDataError.saveError(error)
        }
    }

    func getAllFavorites() -> [FavoritePokemon] {
        let request: NSFetchRequest<FavoritePokemon> = FavoritePokemon.fetchRequest()

        do {
            let result = try context.fetch(request)
            print("✅ Favoriler başarıyla getirildi. Toplam: \(result.count)")
            return result
        } catch {
            print("❌ Failed to fetch favorites: \(error.localizedDescription)")
            return []
        }
    }
}
