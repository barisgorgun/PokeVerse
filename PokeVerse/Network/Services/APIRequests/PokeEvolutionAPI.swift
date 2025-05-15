//
//  PokeEvolutionAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation

struct PokeEvolutionAPI: APIRequest {
    private var evolutionUrl: String

    init(evolutionUrl: String) {
        self.evolutionUrl = evolutionUrl
    }

    var method: HTTPMethod {
        .get
    }

    var path: String {
        ""
    }

    var fullURL: URL? {
        URL(string: evolutionUrl)
    }
}
