//
//  PokemonDisplayItem.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 26.05.2025.
//

import UIKit
import Core

public struct PokemonDisplayItem: Equatable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let url: String
    public let image: UIImage
    public var isFavorite: Bool

    public init(
        id: String,
        name: String,
        url: String,
        image: UIImage,
        isFavorite: Bool
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.image = image
        self.isFavorite = isFavorite
    }

    // 👇 UIImage Hashable olmadığı için manuel implementasyon gerekiyor
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(url)
        hasher.combine(isFavorite)

    }

    public static func == (lhs: PokemonDisplayItem, rhs: PokemonDisplayItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.url == rhs.url &&
        lhs.isFavorite == rhs.isFavorite
    }
}

extension PokemonDisplayItem {
    public init(from favorite: FavoritePokemon, image: UIImage) {
        self.id = favorite.id
        self.name = favorite.name
        self.url = favorite.url
        self.image = image
        self.isFavorite = true
    }
}
