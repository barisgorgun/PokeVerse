//
//  PokemonDetails.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

struct PokemonDetails: Decodable {
    let baseExperience: Int?
    let height: Int?
    let name: String?
    let stats: [Stat]?
    let types: [TypeElement]?
    let weight: Int?

    enum CodingKeys: String, CodingKey {
        case baseExperience = "base_experience"
        case height
        case name
        case stats
        case types
        case weight
    }


    // MARK: - Pairs

    struct Pairs: Decodable {
        let name: String?
        let url: String?
    }


    // MARK: - Stat

    struct Stat:Decodable {
        let baseStat, effort: Int?
        let stat: Pairs?

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort
            case stat
        }

    }

    // MARK: - TypeElement

    struct TypeElement:Decodable {
        let slot: Int?
        let type: Pairs?
    }
}
