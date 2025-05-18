//
//  UIImageView+Extensions.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 17.05.2025.
//

import Kingfisher
import UIKit

extension UIImageView {
    
    func setPokemonImage(id: Int, placeholder: UIImage? = nil) {
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
        self.kf.setImage(
            with: url,
            placeholder: placeholder ?? UIImage(named: "pokemon_placeholder")
        )
    }
}
