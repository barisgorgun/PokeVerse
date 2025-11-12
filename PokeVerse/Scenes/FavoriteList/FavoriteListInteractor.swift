//
//  FavoriteListInteractor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import Foundation
import UIKit
import CoreNetwork
import Core

final class FavoriteListInteractor: FavoriteListInteractorProtocol {
    private let dataStore: FavoritePokemonDataStoreProtocol

    init(dataStore: FavoritePokemonDataStoreProtocol) {
        self.dataStore = dataStore
    }

    func getFavoriteList() async -> [PokemonDisplayItem] {
        let result: [FavoritePokemon] = dataStore.getAllFavorites()

        return await createDisplayItems(from: result)
    }

   private func createDisplayItems(from speciesList: [FavoritePokemon]) async -> [PokemonDisplayItem] {
        var items: [PokemonDisplayItem] = []

        for species in speciesList {
            let image = UIImage(data: species.image ?? Data())
            items.append(PokemonDisplayItem(
                id: species.id,
                name: species.name,
                url: species.url,
                image: image ?? UIImage(),
                isFavorite: true
            ))
        }
        return items
    }

    func removeFavoriteItem(withName id: String) throws {
        do {
            try dataStore.removeFavorite(with: id)
        }
    }
}
