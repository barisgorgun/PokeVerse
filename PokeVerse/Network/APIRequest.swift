//
//  Endpoint.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import Foundation

public protocol APIRequest {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var fullURL: URL? { get }
}

extension APIRequest {
    var baseURL: String {
        "https://pokeapi.co/api/v2"
    }
}

extension APIRequest {
    var fullURL: URL? { nil }
}

public extension APIRequest {
    var urlRequest: URLRequest {
        let url: URL

        if let validFullURL = fullURL {
            url = validFullURL
        } else {
            guard let constructedURL = URL(string: baseURL + path) else {
                fatalError("Geçersiz URL: \(baseURL + path)")
            }
            url = constructedURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
