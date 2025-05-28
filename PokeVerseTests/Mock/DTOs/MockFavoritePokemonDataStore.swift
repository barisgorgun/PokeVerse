//
//  MockFavoritePokemonDataStore.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 27.05.2025.
//

import UIKit

@testable import PokeVerse

final class MockFavoritePokemonDataStore: FavoritePokemonDataStoreProtocol {

    private var favorites: [String: (name: String, url: String, image: UIImage)] = [:]

    func saveFavorite(id: String, name: String, url: String, image: UIImage) throws {
        guard !id.isEmpty, !name.isEmpty else {
            throw CoreDataError.invalidData
        }
        if favorites[id] != nil {
            throw CoreDataError.duplicateEntry
        }
        favorites[id] = (name: name, url: url, image: image)
    }

    func removeFavorite(with id: String) throws {
        if favorites[id] == nil {
            throw CoreDataError.itemNotFound
        }
        favorites.removeValue(forKey: id)
    }

    func isFavorite(id: String) -> Bool {
        favorites[id] != nil
    }

    func getAllFavorites() -> [FavoritePokemon] {
        return []
    }

    func addToFavorites(id: String, name: String = "Bulbasaur", url: String = "https://pokeapi.co/api/v2/pokemon/1", image: UIImage = UIImage()) {
        favorites[id] = (name: name, url: url, image: image)
    }
}
