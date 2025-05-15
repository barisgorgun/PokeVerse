//
//  PokeListRouter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import UIKit

final class PokeListRouter: PokeListRouterProtocol {

    weak var viewController: UIViewController?

    func navigate(to route: PokeListRoute) {
        switch route {
        case .detail(let pokemon):
            let detailVC = PokemonDetailBuilder.build(with: pokemon)
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
