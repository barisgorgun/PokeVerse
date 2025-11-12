//
//  EvolutionChainDetails.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

public struct EvolutionChainDetails : Decodable {
   public let chain: ChainLink
}

public struct ChainLink : Decodable{
    public let species: Species
    public let evolvesTo: [ChainLink]

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}
