//
//  PokeListBuilder.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

struct PokeListBuilder {

    private init() {}

    static func build() -> UIViewController {
        let pokeListService = PokemonListService()
        let router = PokeListRouter()
        let interactor = PokeListInteractor(pokeService: pokeListService)

        let presenter = PokeListPresenter(
            view: nil,
            interactor: interactor,
            router: router
        )

        let view = PokeListViewController(pokeListPresenter: presenter)
        presenter.view = view

        router.viewController = view
        view.navigationItem.backButtonTitle = ""
        return view
    }
}

