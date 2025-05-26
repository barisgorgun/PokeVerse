//
//  FavoriteListBuilder.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import UIKit

struct FavoriteListBuilder {

    private init() {}

    static func build() -> UIViewController {
        let dataStore = FavoritePokemonDataStore()
        let interactor = FavoriteListInteractor(dataStore: dataStore)
        let router = FavoriteListRouter()
        let favoriteListPresenter = FavoriteListPresenter(
            view: nil,
            interactor: interactor,
            router: router
        )

        let view = FavoriteListViewController(favoriteListPresenter: favoriteListPresenter)
        favoriteListPresenter.view = view

        router.viewController = view
        view.navigationItem.backButtonTitle = ""
        return view
    }
}
