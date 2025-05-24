//
//  PokeSpeciesResponseModel.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import Foundation
import UIKit

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

    var imageURL: URL? {
          guard let id = pokemonID else {
              return nil
          }
          return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
      }

    func extractPokemonID(from urlString: String) -> String? {
        let components = urlString.split(separator: "/").compactMap { Int($0) }
        return components.last.map { String($0) }
    }
}


struct PokemonDisplayItem {
    let id: String
    let name: String
    let url: String
    let image: UIImage
    var isFavorite: Bool
}

extension PokemonDisplayItem {
    init(from favorite: FavoritePokemon, image: UIImage) {
        self.id = favorite.id
        self.name = favorite.name
        self.url = ""
        self.image = image
        self.isFavorite = true
    }
}
