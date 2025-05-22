//
//  PokemonDetailPresenter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import Foundation

enum DetailViewType: Int {
    case about = 0
    case stats
    case evolution
}

final class PokemonDetailPresenter: PokemonDetailPresenterProtocol {

    // MARK: - Properties

    weak var view: PokemonDetailViewProtocol?
    private let interactor: PokemonDetailInteractorProtocol

    init(view: PokemonDetailViewProtocol?, interactor: PokemonDetailInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }

    func loadData() {
        Task {
            await view?.showLoading(isLoading: true)
            let result = await interactor.fetchData()

            await view?.showLoading(isLoading: false)

            switch result {
            case .success(let pokemon):
                await view?.showData(pokemon: pokemon)
            case .failure(let error):
                let alert = Alert(message: error.userMessage)
                await view?.showAlert(alert: alert)
            }
        }
    }

    func selectedControllerTapped(at index: Int) {
        guard let viewType = DetailViewType(rawValue: index) else {
            return
        }
        Task { @MainActor in
            switch viewType {
            case .about:
                view?.showInfoView(view: .about)
            case .stats:
                view?.showInfoView(view: .stats)
            case .evolution:
                view?.showInfoView(view: .evolution)
            }
        }
    }
}
