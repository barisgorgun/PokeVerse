//
//  PokeListInteractor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import UIKit

final class PokeListInteractor: PokeListInteractorProtocol {

    private let pokeService: PokemonListServiceProtocol
    private var nextURL: String?
    private let dataStore: FavoritePokemonDataStoreProtocol

    init(pokeService: PokemonListServiceProtocol, dataStore: FavoritePokemonDataStoreProtocol) {
        self.pokeService = pokeService
        self.dataStore = dataStore
    }

    func fetchData() async -> Result<[PokemonDisplayItem], NetworkError> {
        let result = await pokeService.fetchPokemonList()

        switch result {
        case .success(let response):
            nextURL = response.next
            let displayItems = await createDisplayItems(from: response.results)
            return .success(displayItems)
        case .failure(let error):
            return .failure(error)
        }
    }

    func fetchMoreData() async -> Result<[PokemonDisplayItem], NetworkError> {
        guard let nextURL else {
            return .failure(NetworkError.contentEmptyData)
        }

        let result = await pokeService.fetchMoreData(from: nextURL)

        switch result {
        case .success(let response):
            self.nextURL = response.next
            let displayItems = await createDisplayItems(from: response.results)
            return .success(displayItems)
        case .failure(let error):
            return .failure(error)
        }
    }

    func toggleFavorite(for pokemon: PokemonDisplayItem) throws -> Bool {
        let isFavorite = isFavorite(pokemon.id)

        if isFavorite {
            try dataStore.removeFavorite(with: pokemon.id)
            return false
        } else {
            try dataStore.saveFavorite(
                id: pokemon.id,
                name: pokemon.name,
                url: pokemon.url
            )
            return true
        }
    }

    func isFavorite(_ id: String) -> Bool {
        dataStore.isFavorite(id: id)
    }

    private func createDisplayItems(from speciesList: [Species]) async -> [PokemonDisplayItem] {
        var items = Array<PokemonDisplayItem?>(repeating: nil, count: speciesList.count)

        await withTaskGroup(of: (Int, PokemonDisplayItem?).self) { group in
            for (index, species) in speciesList.enumerated() {
                guard let url = species.imageURL else {
                    continue
                }

                group.addTask {
                    let result = await self.pokeService.fetchImages(from: url)
                    switch result {
                    case .success(let image):
                        let pokemonID = species.pokemonID.zeroIfNone()
                        ImageCacheManager.shared.setImage(image, for: "\(pokemonID)")
                        let item = PokemonDisplayItem(
                            id: "\(pokemonID)",
                            name: species.name,
                            url: species.url,
                            image: image,
                            isFavorite: false
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
