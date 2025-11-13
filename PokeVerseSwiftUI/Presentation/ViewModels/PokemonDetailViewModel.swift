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
    private let pokemonUrl: String
    private let isFavorite: Bool
    private var currentPokemon: Pokemon?

    init(
        pokemonDetailService: PokemonDetailServiceProtocol,
        pokemonUrl: String,
        isFavorite: Bool
    ) {
        self.pokemonDetailService = pokemonDetailService
        self.pokemonUrl = pokemonUrl
        self.isFavorite = isFavorite
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
            isFavorite: isFavorite
        )

        currentPokemon = pokemon
        state = .success(pokemon)
    }
}
