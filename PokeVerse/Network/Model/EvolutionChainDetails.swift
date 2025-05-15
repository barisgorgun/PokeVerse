//
//  EvolutionChainDetails.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

struct EvolutionChainDetails : Decodable {
    let chain: ChainLink
}

struct ChainLink : Decodable{
    let species: Species
    let evolvesTo: [ChainLink]

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}
