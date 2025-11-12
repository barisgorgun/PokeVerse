//
//  PokeDetailService.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import Foundation

public protocol PokemonDetailServiceProtocol {
    func fetchSpeciesDetail(pokemonUrl: String) async -> Result<SpeciesDetail, NetworkError>
    func fetchEvouations(evolutionUrl: String) async -> Result<EvolutionChainDetails, NetworkError>
    func fetchPokemonDetails(id: String) async -> Result<PokemonDetails, NetworkError>
}

public final class PokemonDetailService: PokemonDetailServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    public func fetchSpeciesDetail(pokemonUrl: String) async -> Result<SpeciesDetail, NetworkError> {
        let service = SpeciesDetailAPI(pokemonUrl: pokemonUrl)
        return await networkManager.request(service: service, type: SpeciesDetail.self)
    }

    public func fetchEvouations(evolutionUrl: String) async -> Result<EvolutionChainDetails, NetworkError> {
        let service = PokeEvolutionAPI(evolutionUrl: evolutionUrl)
        return await networkManager.request(service: service, type: EvolutionChainDetails.self)
    }

    public func fetchPokemonDetails(id: String) async -> Result<PokemonDetails, NetworkError> {
        let service = PokeDetailAPI(id: id)
        return await networkManager.request(service: service, type: PokemonDetails.self)
    }
}
