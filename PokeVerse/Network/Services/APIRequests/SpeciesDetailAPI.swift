//
//  SpeciesDetailAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation
import CoreNetwork

struct SpeciesDetailAPI: APIRequest {
    private var pokemonUrl: String

    init(pokemonUrl: String) {
        self.pokemonUrl = pokemonUrl
    }

    var method: HTTPMethod {
        .get
    }

    var path: String {
        ""
    }

    var fullURL: URL? {
        URL(string: pokemonUrl)
    }
}
