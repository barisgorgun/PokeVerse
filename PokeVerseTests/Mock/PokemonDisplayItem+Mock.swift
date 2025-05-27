//
//  PokemonDisplayItem+Mock.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 27.05.2025.
//

import UIKit

@testable import PokeVerse

extension PokemonDisplayItem {
    static func mock(
        id: String = "1",
        name: String = "Bulbasaur",
        url: String = "https://pokeapi.co/api/v2/pokemon/1",
        image: UIImage = UIImage(),
        isFavorite: Bool = false
    ) -> PokemonDisplayItem {
        return PokemonDisplayItem(
            id: id,
            name: name,
            url: url,
            image: image,
            isFavorite: isFavorite
        )
    }
}
