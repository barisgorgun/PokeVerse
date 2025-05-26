//
//  FavoriteListRouter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import UIKit

final class FavoriteListRouter: FavoriteListRouterProtocol {

    weak var viewController: UIViewController?

    func navigate(to route: PokeListRoute) {
        switch route {
        case .detail(let pokemonId):
            let detailVC = PokemonDetailBuilder.build(with: pokemonId)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
