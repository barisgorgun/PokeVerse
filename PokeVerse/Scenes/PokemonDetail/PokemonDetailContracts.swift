//
//  PokemonDetailContracts.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import Foundation

// MARK: View

protocol PokemonDetailViewProtocol: AnyObject {
    func handleOutput(_ output: PokemonDetailPresenterOutput)
}

// MARK: Interactor

protocol PokemonDetailInteractorProtocol: AnyObject {
    var delegate: PokemonDetailInteractorDelegate? { get set }

    func fetchData() async
}

protocol PokemonDetailInteractorDelegate: AnyObject {
    func handleOutput(_ output: PokemonDetailInteractorOutput)
}

enum PokemonDetailInteractorOutput {
    case setLoading(Bool)
    case showAlert(NetworkError)
    case showData(Pokemon)
}

// MARK: Presenter

protocol PokemonDetailPresenterProtocol: AnyObject {
    func loadData()
    func selectedControllerTapped(at index: Int)
}

enum PokemonDetailPresenterOutput {
    case setLoading(Bool)
    case showAlert(Alert)
    case showData(Pokemon)
    case showInfoView(DetailViewType)
}
