//
//  Pokemon.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

struct Pokemon {
    let speciesDetail: SpeciesDetailResponseModel
    let evolutionDetails: EvolutionChainDetails
    let pokemonDetails: PokemonDetails

    init(
        speciesDetail: SpeciesDetailResponseModel,
        evolutionDetails: EvolutionChainDetails,
        pokemonDetails: PokemonDetails
    ) {
        self.speciesDetail = speciesDetail
        self.evolutionDetails = evolutionDetails
        self.pokemonDetails = pokemonDetails
    }
}
