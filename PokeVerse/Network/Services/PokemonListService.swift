//
//  PokeListService.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import Foundation
import UIKit


protocol PokemonListServiceProtocol {
    func fetchPokemonList() async -> Result<PokeSpecies, NetworkError>
    func fetchImages(from url: URL) async -> Result<UIImage, NetworkError>
    func fetchMoreData(from url: String) async -> Result<PokeSpecies, NetworkError>
}

final class PokemonListService: PokemonListServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchPokemonList() async -> Result<PokeSpecies, NetworkError> {
        let service = PokemonListAPI()
        return await networkManager.request(service: service, type: PokeSpecies.self)
    }

    func fetchMoreData(from url: String) async -> Result<PokeSpecies, NetworkError> {
        let service = PokemonListAPI(nextUrl: url)
        return await networkManager.request(service: service, type: PokeSpecies.self)
    }

    func fetchImages(from url: URL) async -> Result<UIImage, NetworkError> {
        await networkManager.requestImage(from: url)
    }
}
