//
//  PokemonDisplayItem.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 26.05.2025.
//

import UIKit

struct PokemonDisplayItem {
    let id: String
    let name: String
    let url: String
    let image: UIImage
    var isFavorite: Bool
}

extension PokemonDisplayItem {
    init(from favorite: FavoritePokemon, image: UIImage) {
        self.id = favorite.id
        self.name = favorite.name
        self.url = favorite.url
        self.image = image
        self.isFavorite = true
    }
}
