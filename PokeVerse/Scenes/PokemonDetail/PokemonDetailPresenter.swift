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

        self.interactor.delegate = self
    }


    func loadData() {
        Task {
            await interactor.fetchData()
        }
    }

    func selectedControllerTapped(at index: Int) {
        guard let viewType = DetailViewType(rawValue: index) else {
            return
        }

        switch viewType {
        case .about:
            view?.handleOutput(.showInfoView(.about))
        case .stats:
            view?.handleOutput(.showInfoView(.stats))
        case .evolution:
            view?.handleOutput(.showInfoView(.evolution))
        }
    }
}

// MARK: - PokemonDetailInteractorDelegate

extension PokemonDetailPresenter: PokemonDetailInteractorDelegate {
    func handleOutput(_ output: PokemonDetailInteractorOutput) {
        switch output {
        case .setLoading(let isLoading):
            view?.handleOutput(.setLoading(isLoading))
        case .showAlert(let error):
            let alert = Alert(message: error.localizedDescription)
            view?.handleOutput(.showAlert(alert))
        case .showData(let data):
            view?.handleOutput(.showData(data))
        }
    }
}
