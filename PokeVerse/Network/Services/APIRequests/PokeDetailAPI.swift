//
//  PokeDetailAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation
import CoreNetwork

struct PokeDetailAPI: APIRequest {

    private var id: String

    init(id: String) {
        self.id = id
    }

    var method: HTTPMethod {
        .get
    }

    var path: String {
        "/pokemon/\(id)"
    }

    var fullURL: URL? {
        nil
    }
}
