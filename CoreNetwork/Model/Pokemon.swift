//
//  Pokemon.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

public struct Pokemon: Equatable {
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        true
    }
    
    public let speciesDetail: SpeciesDetail
    public let evolutionDetails: EvolutionChainDetails
    public let pokemonDetails: PokemonDetails

    public init(
        speciesDetail: SpeciesDetail,
        evolutionDetails: EvolutionChainDetails,
        pokemonDetails: PokemonDetails
    ) {
        self.speciesDetail = speciesDetail
        self.evolutionDetails = evolutionDetails
        self.pokemonDetails = pokemonDetails
    }
}
