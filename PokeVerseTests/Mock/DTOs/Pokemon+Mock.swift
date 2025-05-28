//
//  Pokemon+Mock.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 27.05.2025.
//

import Foundation
@testable import PokeVerse

extension Pokemon {
    static func mock() -> Pokemon {
        let speciesDetail = SpeciesDetail(
            id: 1,
            name: "bulbasaur",
            color: SpeciesDetail.PokemonColor(name: "green"),
            genera: [
                SpeciesDetail.PokemonGenus(genus: "Seed Pokémon", language: .init(name: "en"))
            ],
            flavorTextEntries: [
                SpeciesDetail.FlavorTextEntry(
                    flavorText: "A strange seed was planted on its back at birth.",
                    language: .init(name: "en"),
                    version: .init(name: "red")
                )
            ],
            baseHappiness: 70,
            captureRate: 45,
            eggGroups: [SpeciesDetail.PokemonEggGroup(name: "monster")],
            evolutionChain: .init(url: "https://pokeapi.co/api/v2/evolution-chain/1/")
        )

        let evolutionDetails = EvolutionChainDetails(
            chain: ChainLink(
                species: Species(name: "bulbasaur", url: ""),
                evolvesTo: []
            )
        )

        let pokemonDetails = PokemonDetails(
            baseExperience: 64,
            height: 7,
            name: "bulbasaur",
            stats: [
                .init(baseStat: 45, effort: 0, stat: .init(name: "hp", url: nil))
            ],
            types: [
                .init(slot: 1, type: .init(name: "grass", url: nil))
            ],
            weight: 69
        )

        return Pokemon(
            speciesDetail: speciesDetail,
            evolutionDetails: evolutionDetails,
            pokemonDetails: pokemonDetails
        )
    }
}
