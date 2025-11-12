//
//  PokeDetailResponseModel.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

import Foundation

public struct SpeciesDetail: Codable {
    public let id: Int
    public let name: String
    public let color: PokemonColor
    public let genera: [PokemonGenus]
    public let flavorTextEntries: [FlavorTextEntry]
    public let baseHappiness: Int?
    public let captureRate: Int?
    public let eggGroups: [PokemonEggGroup]
    public let evolutionChain: EvolutionChain?

    public struct PokemonColor: Codable {
        public let name: String
    }

   public struct PokemonGenus: Codable {
        public let genus: String
        public let language: Language
    }

    public struct FlavorTextEntry: Codable {
        public let flavorText: String
        public let language: Language
        public let version: GameVersion

        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language, version
        }
    }

    public struct PokemonEggGroup: Codable {
        public let name: String
    }

    public struct EvolutionChain: Codable {
        public let url: String
    }

    public struct Language: Codable {
        public let name: String
    }

    public struct GameVersion: Codable {
        public let name: String
    }

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case id, name, color, genera
        case flavorTextEntries = "flavor_text_entries"
        case baseHappiness = "base_happiness"
        case captureRate = "capture_rate"
        case eggGroups = "egg_groups"
        case evolutionChain = "evolution_chain"
    }

    public func getLocalizedGenus(for language: String = "en") -> String? {
        genera.first { $0.language.name == language }?.genus
    }

    public func getLatestFlavorText() -> String? {
        flavorTextEntries
            .filter { $0.language.name == "en" }
            .sorted { $0.version.name > $1.version.name }
            .first?
            .flavorText
            .replacingOccurrences(of: "\n", with: " ")
    }
}
