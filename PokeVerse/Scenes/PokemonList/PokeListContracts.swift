//
//  PokeListContracts.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import UIKit

// MARK: - View

@MainActor
protocol PokeListViewProtocol: AnyObject {
    func showPokeList(species: [PokemonDisplayItem])
    func showAlert(alert: Alert)
    func showLoading(isLoading: Bool)
    func updateFavoriteStatus(at indexPath: IndexPath, isFavorite: Bool)
}

// MARK: - Interactor

protocol PokeListInteractorProtocol: AnyObject {
    func fetchData() async -> Result<[PokemonDisplayItem], NetworkError>
    func fetchMoreData() async -> Result<[PokemonDisplayItem], NetworkError>
    func toggleFavorite(for pokemon: PokemonDisplayItem) throws -> Bool
    func isFavorite(_ id: String) -> Bool
}

// MARK: - Presenter

protocol PokeListPresenterProtocol: AnyObject {
    var view: PokeListViewProtocol? { get set }

    func load()
    func didSelectPoke(at index: Int)
    func prefetchIfNeeded(for indexPaths: [IndexPath])
    func didTapFavorite(at indexPath: IndexPath)
    func isFavorite(at id: String) -> Bool
}

// MARK: - Router

enum PokeListRoute {
    case detail(String)
}

protocol PokeListRouterProtocol: AnyObject {
    func navigate(to route: PokeListRoute)
}
