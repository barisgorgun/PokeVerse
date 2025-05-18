//
//  PokeSpeciesResponseModel.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import Foundation

// MARK: - PokeSpecies

struct PokeSpecies: Codable, Equatable {
    let next: String?
    let results: [Species]
}

// MARK: - Species

struct Species: Codable, Equatable {
    let name: String
    let url: String
}


extension Species {
    var pokemonID: Int? {
        guard let id = extractPokemonID(from: url) else {
            return nil
        }
        return Int(id)
    }

    func extractPokemonID(from urlString: String) -> String? {
        let components = urlString.split(separator: "/").compactMap { Int($0) }
        return components.last.map { String($0) }
    }
}
