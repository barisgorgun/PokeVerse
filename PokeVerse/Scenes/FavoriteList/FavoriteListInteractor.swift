//
//  FavoriteListInteractor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import Foundation
import UIKit

final class FavoriteListInteractor: FavoriteListInteractorProtocol {
    private let dataStore: FavoritePokemonDataStoreProtocol

    init(dataStore: FavoritePokemonDataStoreProtocol) {
        self.dataStore = dataStore
    }

    func getFavoriteList() -> [PokemonDisplayItem] {
        var pokemonList: [PokemonDisplayItem] = []

        let result: [FavoritePokemon] = dataStore.getAllFavorites()

        for item in result {
            let image = ImageCacheManager.shared.getImage(for: item.id)
            let displayItem = PokemonDisplayItem(from: item, image: image ?? UIImage())
            pokemonList.append(displayItem)
        }

        return pokemonList
    }

    func removeFavoriteItem(withName id: String) throws {
        do {
            try dataStore.removeFavorite(with: id)
        }
    }
}
