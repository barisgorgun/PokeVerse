//
//  PokemonDetailInteractor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import Foundation

final class PokemonDetailInteractor: PokemonDetailInteractorProtocol {

    weak var delegate: PokemonDetailInteractorDelegate?
    private let pokomenDetailService: PokemonDetailServiceProtocol
    private let pokemonUrl: String
    private var speciesDetail: SpeciesDetail?
    private var evolutionDetails: EvolutionChainDetails?
    private var pokemonDetails: PokemonDetails?

    init(pokomenDetailService: PokemonDetailServiceProtocol, pokemonUrl: String) {
        self.pokomenDetailService = pokomenDetailService
        self.pokemonUrl = pokemonUrl
    }

    func fetchData() async {
        delegate?.handleOutput(.setLoading(true))

        let result = await pokomenDetailService.fetchSpeciesDetail(pokemonUrl: pokemonUrl)

        switch result {
        case .success(let response):
            speciesDetail = response
            await fetchEvouations(response.evolutionChain?.url ?? "", id: "\(response.id)")
        case .failure(let error):
            delegate?.handleOutput(.showAlert(error))
        }
    }

    private func fetchEvouations(_ evouationUrl: String, id: String) async {
        let result = await pokomenDetailService.fetchEvouations(evolutionUrl: evouationUrl)

        switch result {
        case .success(let response):
            evolutionDetails = response
            await fetchSpeciesDetail(id: id)
        case .failure(let error):
            delegate?.handleOutput(.showAlert(error))
        }
    }

    private func fetchSpeciesDetail(id: String) async {
        let result = await pokomenDetailService.fetchPokemonDetails(id: id)
        delegate?.handleOutput(.setLoading(false))
        switch result {
        case .success(let response):
            pokemonDetails = response
            guard let speciesDetail, let evolutionDetails, let pokemonDetails else {
                return
            }

            let pokemon = Pokemon(
                speciesDetail: speciesDetail,
                evolutionDetails: evolutionDetails,
                pokemonDetails: pokemonDetails
            )
            delegate?.handleOutput(.showData(pokemon))
        case .failure(let error):
            delegate?.handleOutput(.showAlert(error))
        }
    }
}
