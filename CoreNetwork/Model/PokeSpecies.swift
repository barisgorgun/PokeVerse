//
//  PokeSpeciesResponseModel.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import Foundation
import UIKit

// MARK: - PokeSpecies

public struct PokeSpecies: Codable, Equatable {
    public let next: String?
    public let results: [Species]
}

// MARK: - Species

public struct Species: Codable, Equatable {
    public let name: String
    public let url: String
}

extension Species {
    public var pokemonID: Int? {
        guard let id = extractPokemonID(from: url) else {
            return nil
        }
        return Int(id)
    }

    public var imageURL: URL? {
        guard let id = pokemonID else {
            return nil
        }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
    }

    public func extractPokemonID(from urlString: String) -> String? {
        let components = urlString.split(separator: "/").compactMap { Int($0) }
        return components.last.map { String($0) }
    }
}
