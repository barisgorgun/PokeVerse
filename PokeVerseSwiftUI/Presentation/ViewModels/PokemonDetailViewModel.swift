//
//  PokemonDetailViewModel.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import Foundation
import Combine
import CoreNetwork

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var state: ViewState<Pokemon> = .idle

    private var pokemonDetailService: PokemonDetailServiceProtocol
    private var pokemonUrl: String

    init(pokemonDetailService: PokemonDetailServiceProtocol, pokemonUrl: String) {
        self.pokemonDetailService = pokemonDetailService
        self.pokemonUrl = pokemonUrl
    }

    func fetchData() async {
        state = .loading

        let speciesResult = await pokemonDetailService.fetchSpeciesDetail(pokemonUrl: pokemonUrl)

        guard case .success(let speciesDetail) = speciesResult else {
            state = .error(NetworkError.contentEmptyData.userMessage)
            return
        }

        guard let evolutionUrl = speciesDetail.evolutionChain?.url else {
            state = .error(NetworkError.invalidURL.userMessage)
            return
        }

        async let evolutionResult = pokemonDetailService.fetchEvouations(evolutionUrl: evolutionUrl)
        async let detailsResult = pokemonDetailService.fetchPokemonDetails(id: "\(speciesDetail.id)")

        let (evoRes, detailsRes) = await (evolutionResult, detailsResult)

        guard case .success(let evolutions) = evoRes,
              case .success(let pokemonDetails) = detailsRes else {
            state = .error(NetworkError.contentEmptyData.userMessage)
            return
        }


        let pokemon = Pokemon(
            speciesDetail: speciesDetail,
            evolutionDetails: evolutions,
            pokemonDetails: pokemonDetails
        )

        state = .success(pokemon)
    }
}
