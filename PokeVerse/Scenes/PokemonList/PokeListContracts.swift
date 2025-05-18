//
//  PokeListContracts.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import UIKit

// MARK: - View

protocol PokeListViewProtocol: AnyObject {
    func handleOutput(_ output: PokeListPresenterOutput)
}

// MARK: - Interactor

protocol PokeListInteractorProtocol: AnyObject {
    var delegate: PokeListInteractorDelegate? { get set }

    func fetchData() async
    func fetchMoreData() async
}

enum PokeListInteractorOutput: Equatable {
    case setLoading(Bool)
    case showPokeList([Species])
    case showAlert(NetworkError)
}

protocol PokeListInteractorDelegate: AnyObject {
    func handleOutput(_ output: PokeListInteractorOutput)
}

// MARK: - Presenter

protocol PokeListPresenterProtocol: AnyObject {
    func load()
    func loadMoreData()
    func didSelectPoke(at index: Int)
}

enum PokeListPresenterOutput: Equatable {
    case setLoading(Bool)
    case showPokeList([Species])
    case showAlert(Alert)
}

// MARK: - Router

enum PokeListRoute {
    case detail(String)
}

protocol PokeListRouterProtocol: AnyObject {
    func navigate(to route: PokeListRoute)
}
