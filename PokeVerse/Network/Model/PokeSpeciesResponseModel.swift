//
//  PokeSpeciesResponseModel.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import Foundation

// MARK: - PokeSpeciesResponseModel

struct PokeSpeciesResponseModel: Codable {
    let next: String?
    let results: [Species]
}

// MARK: - Species

struct Species: Codable {
    let name: String
    let url: String
}


extension Species {
    var imageURL: URL? {
        guard let id = extractPokemonID(from: url) else { return nil }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }

    private func extractPokemonID(from urlString: String) -> String? {
        let components = urlString.split(separator: "/").compactMap { Int($0) }
        return components.last.map { String($0) }
    }
}
