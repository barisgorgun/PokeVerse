//
//  PokeListBuilder.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit
import CoreNetwork
import Core

struct PokeListBuilder {

    private init() {}

    static func build(analytics: AnalyticsTracking) -> UIViewController {
        let pokeListService = PokemonListService()
        let router = PokeListRouter()
        let dataStore = FavoritePokemonDataStore()
        let interactor = PokeListInteractor(pokeService: pokeListService, dataStore: dataStore)

        let presenter = PokeListPresenter(
            view: nil,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        let view = PokeListViewController(pokeListPresenter: presenter)
        presenter.view = view

        router.viewController = view
        view.navigationItem.backButtonTitle = ""
        return view
    }
}

