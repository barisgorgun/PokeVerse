//
//  PokeEvolutionAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation

public struct PokeEvolutionAPI: APIRequest {
    private var evolutionUrl: String

    public init(evolutionUrl: String) {
        self.evolutionUrl = evolutionUrl
    }

    public var method: HTTPMethod {
        .get
    }

    public var path: String {
        ""
    }

    public var fullURL: URL? {
        URL(string: evolutionUrl)
    }
}
