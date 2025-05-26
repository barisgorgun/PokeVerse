//
//  FavoriteListContracts.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import Foundation

// MARK: - View

@MainActor
protocol FavoriteListViewProtocol: AnyObject {
    func reloadData(with species: [PokemonDisplayItem])
    func showAlert(alert: Alert)
}

// MARK: - Presenter

protocol FavoriteListPresenterProtocol: AnyObject {
    var view: FavoriteListViewProtocol? { get set }

    func load()
    func didSelectPoke(at index: Int)
    func didTapFavorite(at indexPath: IndexPath)
    func didReceiveFavoriteChange()
}

// MARK: - Interactor

protocol FavoriteListInteractorProtocol: AnyObject {
    func removeFavoriteItem(withName id: String) throws
    func getFavoriteList() -> [PokemonDisplayItem]
}

// MARK: - Router

protocol FavoriteListRouterProtocol: AnyObject {
    func navigate(to route: PokeListRoute)
}
