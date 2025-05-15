//
//  PokeDetailResponseModel.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

struct SpeciesDetail: Codable {
    let id: Int
    let name: String
    let color: PokemonColor
    let genera: [PokemonGenus]
    let flavorTextEntries: [FlavorTextEntry]
    let baseHappiness: Int?
    let captureRate: Int?
    let eggGroups: [PokemonEggGroup]

    let evolutionChain: EvolutionChain?

    struct PokemonColor: Codable {
        let name: String
    }

    struct PokemonGenus: Codable {
        let genus: String
        let language: Language
    }

    struct FlavorTextEntry: Codable {
        let flavorText: String
        let language: Language
        let version: GameVersion

        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language, version
        }
    }

    struct PokemonEggGroup: Codable {
        let name: String
    }

    struct EvolutionChain: Codable {
        let url: String
    }

    struct Language: Codable {
        let name: String
    }

    struct GameVersion: Codable {
        let name: String
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

    func getLocalizedGenus(for language: String = "en") -> String? {
        return genera.first { $0.language.name == language }?.genus
    }

    func getLatestFlavorText() -> String? {
        return flavorTextEntries
            .filter { $0.language.name == "en" }
            .sorted { $0.version.name > $1.version.name }
            .first?
            .flavorText
            .replacingOccurrences(of: "\n", with: " ")
    }
}
