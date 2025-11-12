//
//  SpeciesDetailAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation

public struct SpeciesDetailAPI: APIRequest {
    private var pokemonUrl: String

    public init(pokemonUrl: String) {
        self.pokemonUrl = pokemonUrl
    }

    public var method: HTTPMethod {
        .get
    }

    public var path: String {
        ""
    }

    public var fullURL: URL? {
        URL(string: pokemonUrl)
    }
}
