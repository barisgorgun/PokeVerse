//
//  PokeDetailAPI.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 14.05.2025.
//

import Foundation

public struct PokeDetailAPI: APIRequest {

    private var id: String

    public init(id: String) {
        self.id = id
    }

    public var method: HTTPMethod {
        .get
    }

    public var path: String {
        "/pokemon/\(id)"
    }

    public var fullURL: URL? {
        nil
    }
}
