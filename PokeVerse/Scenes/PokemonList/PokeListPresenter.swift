//
//  PokeListPresenter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import Foundation

final class PokeListPresenter: PokeListPresenterProtocol {

    // MARK: - Private properties

    weak var view: PokeListViewProtocol?
    private let interactor: PokeListInteractorProtocol
    private let router: PokeListRouterProtocol
    private var pokeList: [Species] = []

    init(
        view: PokeListViewProtocol?,
        interactor: PokeListInteractorProtocol,
        router: PokeListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router

        self.interactor.delegate = self
    }

    // MARK: - Protocol funcs
    
    func load() {
        Task {
            await interactor.fetchData()
        }
    }

    func loadMoreData() {
        Task {
            await interactor.fetchMoreData()
        }
    }

    func didSelectPoke(at index: Int) {
        guard pokeList.indices.contains(index) else {
            return
        }

        let poke = pokeList[index].url
        router.navigate(to: .detail(poke))
    }
}

// MARK: - PokeListInteractorDelegate

extension PokeListPresenter: PokeListInteractorDelegate {

    func handleOutput(_ output: PokeListInteractorOutput) {
        switch output {
        case .setLoading(let isLoading):
            view?.handleOutput(.setLoading(isLoading))
        case .showPokeList(let pokelist):
            self.pokeList.append(contentsOf: pokelist)
            view?.handleOutput(.showPokeList(pokelist))
        case .showAlert(let error):
            let alert = Alert(messsage: error.localizedDescription)
            view?.handleOutput(.showAlert(alert))
        }
    }
}
