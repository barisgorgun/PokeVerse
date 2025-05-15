//
//  PokeDetailService.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import Foundation


protocol PokemonDetailServiceProtocol {
    func fetchSpeciesDetail(pokemonUrl: String) async -> Result<SpeciesDetailResponseModel, NetworkError>
    func fetchEvouations(evolutionUrl: String) async -> Result<EvolutionChainDetails, NetworkError>
    func fetchPokemonDetails(id: String) async -> Result<PokemonDetails, NetworkError>
}


final class PokemonDetailService: PokemonDetailServiceProtocol {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchSpeciesDetail(pokemonUrl: String) async -> Result<SpeciesDetailResponseModel, NetworkError> {
        let service = SpeciesDetailAPI(pokemonUrl: pokemonUrl)
        return await networkManager.request(service: service, type: SpeciesDetailResponseModel.self)
    }

    func fetchEvouations(evolutionUrl: String) async -> Result<EvolutionChainDetails, NetworkError> {
        let service = PokeEvolutionAPI(evolutionUrl: evolutionUrl)
        return await networkManager.request(service: service, type: EvolutionChainDetails.self)
    }

    func fetchPokemonDetails(id: String) async -> Result<PokemonDetails, NetworkError> {
        let service = PokeDetailAPI(id: id)
        return await networkManager.request(service: service, type: PokemonDetails.self)
    }
}
