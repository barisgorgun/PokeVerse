//
//  PokemonDetails.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

public struct PokemonDetails: Decodable {
    public let baseExperience: Int?
    public let height: Int?
    public let name: String?
    public let stats: [Stat]?
    public let types: [TypeElement]?
    public let weight: Int?

    enum CodingKeys: String, CodingKey {
        case baseExperience = "base_experience"
        case height
        case name
        case stats
        case types
        case weight
    }


    // MARK: - Pairs

    public struct Pairs: Decodable {
        public let name: String?
        public let url: String?
    }


    // MARK: - Stat

    public struct Stat:Decodable {
        public let baseStat, effort: Int?
        public let stat: Pairs?

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort
            case stat
        }

    }

    // MARK: - TypeElement

    public struct TypeElement:Decodable {
        public let slot: Int?
        public let type: Pairs?
    }
}
