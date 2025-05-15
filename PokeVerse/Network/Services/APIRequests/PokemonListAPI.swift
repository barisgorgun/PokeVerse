//
//  PokemonListAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation

struct PokemonListAPI: APIRequest {
    var path: String {
        "/pokemon-species"
    }

    var method: HTTPMethod {
        .get
    }

    private var nextUrl: String?

    init(nextUrl: String? = nil) {
         self.nextUrl = nextUrl
     }

    var fullURL: URL? {
        if let nextUrl {
            return URL(string: nextUrl)
        }
        return nil
    }
}
