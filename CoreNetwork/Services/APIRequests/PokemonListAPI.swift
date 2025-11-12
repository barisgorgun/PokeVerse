//
//  PokemonListAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation

public struct PokemonListAPI: APIRequest {
    public var path: String {
        "/pokemon-species"
    }

    public var method: HTTPMethod {
        .get
    }

    private var nextUrl: String?

    public init(nextUrl: String? = nil) {
         self.nextUrl = nextUrl
     }

    public var fullURL: URL? {
        if let nextUrl {
            return URL(string: nextUrl)
        }
        return nil
    }
}
