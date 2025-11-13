//
//  PokemonListViewModel.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 11.11.2025.
//

import Foundation
import Combine
import CoreNetwork
import Core
import SwiftUI

@MainActor
final class PokeListViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[PokemonDisplayItem]> = .idle
    @Published var selectedPokemon: PokemonDisplayItem? = nil

    private let pokeListService: PokemonListServiceProtocol
    private let cache: ImageCacheActorProtocol
    private let dataStore: FavoritePokemonDataStoreProtocol
    private var pokemons: [PokemonDisplayItem] = []
    private var favorites: FavoriteListViewModel?
    private var cancellables = Set<AnyCancellable>()

    init(
        pokeListService: PokemonListServiceProtocol,
        cache: ImageCacheActorProtocol = ImageCacheActor.shared,
        dataStore: FavoritePokemonDataStoreProtocol,
        favorites: FavoriteListViewModel? = nil
    ) {
        self.pokeListService = pokeListService
        self.cache = cache
        self.dataStore = dataStore
        self.favorites = favorites

        setupFavoritesListener()
    }

    func loadPokemons() async {
        state = .loading
        let result = await pokeListService.fetchPokemonList()

        switch result {
        case .success(let response):
            pokemons = await createDisplayItems(from: response.results)
            state = .success(pokemons)
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }

    private func setupFavoritesListener() {
        favorites?.$favorites
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func setFavorites(_ fav: FavoriteListViewModel) {
        self.favorites = fav
        setupFavoritesListener()
    }

    private func createDisplayItems(from speciesList: [Species]) async -> [PokemonDisplayItem] {
        var items = Array<PokemonDisplayItem?>(repeating: nil, count: speciesList.count)

        await withTaskGroup(of: (Int, PokemonDisplayItem?).self) { group in
            for (index, species) in speciesList.enumerated() {
                guard let url = species.imageURL else { continue }

                group.addTask { [weak self] in
                    guard let self else { return (index, nil) }

                    if let cached = await self.cache.getImage(for: url) {
                        let item = PokemonDisplayItem(
                            id: "\(species.pokemonID ?? 0)",
                            name: species.name,
                            url: species.url,
                            image: cached
                        )
                        return (index, item)
                    }

                    let result = await self.pokeListService.fetchImages(from: url)
                    switch result {
                    case .success(let image):
                        await self.cache.setImage(image, for: url)
                        let item = PokemonDisplayItem(
                            id: "\(species.pokemonID ?? 0)",
                            name: species.name,
                            url: species.url,
                            image: image
                        )
                        return (index, item)
                    case .failure:
                        return (index, nil)
                    }
                }
            }

            for await (index, item) in group {
                items[index] = item
            }
        }

        return items.compactMap { $0 }
    }
}
