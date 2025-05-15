//
//  PokemonDetailBuilder.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

struct PokemonDetailBuilder {

    private init() {}

    static func build(with pokemon: String) -> UIViewController {
        let detailService = PokemonDetailService()
        let interactor = PokemonDetailInteractor(pokomenDetailService: detailService, pokemonUrl: pokemon)
        let presenter = PokemonDetailPresenter(view: nil, interactor: interactor)
        let view = PokemonDetailViewController(pokeDetailPresenter: presenter)
        presenter.view = view
        return view
    }
}
