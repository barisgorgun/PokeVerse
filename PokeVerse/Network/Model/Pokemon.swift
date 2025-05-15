//
//  Pokemon.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

struct Pokemon {
    let speciesDetail: SpeciesDetail
    let evolutionDetails: EvolutionChainDetails
    let pokemonDetails: PokemonDetails

    init(
        speciesDetail: SpeciesDetail,
        evolutionDetails: EvolutionChainDetails,
        pokemonDetails: PokemonDetails
    ) {
        self.speciesDetail = speciesDetail
        self.evolutionDetails = evolutionDetails
        self.pokemonDetails = pokemonDetails
    }
}
