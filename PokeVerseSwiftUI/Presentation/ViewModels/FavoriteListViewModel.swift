//
//  FavoriteListViewModel.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 13.11.2025.
//

import Foundation
import Combine
import CoreNetwork
import Core
import UIKit
import SwiftUI

@MainActor
final class FavoriteListViewModel: ObservableObject {
    @Published var state: ViewState<[PokemonDisplayItem]> = .idle
    @Published private(set) var favorites: [PokemonDisplayItem] = []
    @Published var selectedPokemon: PokemonDisplayItem? = nil

    private let dataStore: FavoritePokemonDataStoreProtocol

    init(dataStore: FavoritePokemonDataStoreProtocol = FavoritePokemonDataStore()) {
        self.dataStore = dataStore
    }

    func loadFavorites() async {
        state = .loading

        let stored = dataStore.getAllFavorites()
        let items = await createDisplayItems(from: stored)

        favorites = items
        state = .success(items)
    }

    private func createDisplayItems(from speciesList: [FavoritePokemon]) async -> [PokemonDisplayItem] {
         var items: [PokemonDisplayItem] = []

         for species in speciesList {
             let image = UIImage(data: species.image ?? Data())
             items.append(PokemonDisplayItem(
                 id: species.id,
                 name: species.name,
                 url: species.url,
                 image: image ?? UIImage()
             ))
         }
         return items
     }

    func toggleFavorite(for item: PokemonDisplayItem) async {
        do {
            let isFav = isFavorite(for: item.id)

            if isFav {
                try dataStore.removeFavorite(with: item.id)
            } else {
                try dataStore.saveFavorite(
                    id: item.id,
                    name: item.name,
                    url: item.url,
                    image: item.image
                )
            }

            await loadFavorites()

        } catch {
            state = .error("Failed to update favorite: \(error.localizedDescription)")
        }
    }

    func isFavorite(for id: String) -> Bool {
        dataStore.isFavorite(id: id)
    }
}
