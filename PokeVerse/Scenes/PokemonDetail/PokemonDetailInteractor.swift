//
//  PokemonDetailInteractor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import Foundation
import CoreNetwork

final class PokemonDetailInteractor: PokemonDetailInteractorProtocol {
    private let pokemonDetailService: PokemonDetailServiceProtocol
    private let pokemonUrl: String
    private var speciesDetail: SpeciesDetail?
    private var evolutionDetails: EvolutionChainDetails?
    private var pokemonDetails: PokemonDetails?

    init(pokemonDetailService: PokemonDetailServiceProtocol, pokemonUrl: String) {
        self.pokemonDetailService = pokemonDetailService
        self.pokemonUrl = pokemonUrl
    }

    func fetchData() async -> Result<Pokemon, NetworkError> {
        let speciesResult = await pokemonDetailService.fetchSpeciesDetail(pokemonUrl: pokemonUrl)

        guard case .success(let speciesDetail) = speciesResult else {
            return .failure(NetworkError.contentEmptyData)
        }

        guard let evolutionUrl = speciesDetail.evolutionChain?.url else {
            return .failure(NetworkError.invalidURL)
        }

        let evolutionResult = await pokemonDetailService.fetchEvouations(evolutionUrl: evolutionUrl)

        guard case .success(let evolutionDetails) = evolutionResult else {
            return .failure(NetworkError.contentEmptyData)
        }

        let detailsResult = await pokemonDetailService.fetchPokemonDetails(id: "\(speciesDetail.id)")

        guard case .success(let pokemonDetails) = detailsResult else {
            return .failure(NetworkError.contentEmptyData)
        }

        let pokemon = Pokemon(
            speciesDetail: speciesDetail,
            evolutionDetails: evolutionDetails,
            pokemonDetails: pokemonDetails,
            isFavorite: false
        )

        return .success(pokemon)
    }
}
