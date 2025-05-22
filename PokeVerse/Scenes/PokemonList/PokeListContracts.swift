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
}

// MARK: - Interactor

protocol PokeListInteractorProtocol: AnyObject {
    func fetchData() async -> Result<[PokemonDisplayItem], NetworkError>
    func fetchMoreData() async -> Result<[PokemonDisplayItem], NetworkError>
}

// MARK: - Presenter

protocol PokeListPresenterProtocol: AnyObject {
    func load()
    func didSelectPoke(at index: Int)
    func prefetchIfNeeded(for indexPaths: [IndexPath])
}

// MARK: - Router

enum PokeListRoute {
    case detail(String)
}

protocol PokeListRouterProtocol: AnyObject {
    func navigate(to route: PokeListRoute)
}
