//
//  PokemonDetailContracts.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import Foundation
import CoreNetwork
import Core

// MARK: View

@MainActor
protocol PokemonDetailViewProtocol: AnyObject {
    func showData(pokemon: Pokemon)
    func showAlert(alert: Alert)
    func showLoading(isLoading: Bool)
    func showInfoView(view: DetailViewType)
}

// MARK: Interactor

protocol PokemonDetailInteractorProtocol: AnyObject {
    func fetchData() async -> Result<Pokemon, NetworkError>
}

// MARK: Presenter

protocol PokemonDetailPresenterProtocol: AnyObject {
    func loadData() async
    func selectedControllerTapped(at index: Int)
}
