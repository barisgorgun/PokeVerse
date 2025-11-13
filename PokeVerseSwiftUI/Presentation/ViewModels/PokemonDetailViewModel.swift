//
//  PokemonDetailViewModel.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import Foundation
import Combine
import CoreNetwork
import Core
import SwiftUI

@MainActor
final class PokemonDetailViewModel: ObservableObject {

    @Published var state: ViewState<Pokemon> = .idle

    private let pokemonDetailService: PokemonDetailServiceProtocol
    private var favorites: FavoriteListViewModel
    private let pokemonUrl: String

    private var cancellables = Set<AnyCancellable>()
    private var currentPokemon: Pokemon?

    init(
        pokemonDetailService: PokemonDetailServiceProtocol,
        pokemonUrl: String,
        favorites: FavoriteListViewModel
    ) {
        self.pokemonDetailService = pokemonDetailService
        self.pokemonUrl = pokemonUrl
        self.favorites = favorites

        setupFavoritesListener()
    }

    private func setupFavoritesListener() {
        favorites.$favorites
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func setFavorites(_ fav: FavoriteListViewModel) {
        self.favorites = fav
        setupFavoritesListener()
    }

    func fetchData() async {
        state = .loading

        let speciesRes = await pokemonDetailService.fetchSpeciesDetail(pokemonUrl: pokemonUrl)
        guard case .success(let speciesDetail) = speciesRes else {
            state = .error("Species error")
            return
        }

        async let evoRes = pokemonDetailService.fetchEvouations(evolutionUrl: speciesDetail.evolutionChain?.url ?? "")
        async let detailRes = pokemonDetailService.fetchPokemonDetails(id: "\(speciesDetail.id)")

        guard case .success(let evolution) = await evoRes,
              case .success(let details) = await detailRes else {
            state = .error("Detail error")
            return
        }

        let pokemon = Pokemon(
            speciesDetail: speciesDetail,
            evolutionDetails: evolution,
            pokemonDetails: details,
            isFavorite: favorites.isFavorite(for: "\(speciesDetail.id)")
        )

        currentPokemon = pokemon
        state = .success(pokemon)
    }
}
