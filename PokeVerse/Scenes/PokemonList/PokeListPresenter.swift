//
//  PokeListPresenter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import Foundation

final class PokeListPresenter: PokeListPresenterProtocol {

    // MARK: - Properties

    weak var view: PokeListViewProtocol?
    private let interactor: PokeListInteractorProtocol
    private let router: PokeListRouterProtocol
    private(set) var pokeList: [PokemonDisplayItem] = []
    private var isLoadingMore = false
    private var hasMorePages = true

    init(
        view: PokeListViewProtocol?,
        interactor: PokeListInteractorProtocol,
        router: PokeListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func load() {
        Task {
            await view?.showLoading(isLoading: true)
            let result = await interactor.fetchData()

            await view?.showLoading(isLoading: false)

            switch result {
            case .success(let pokeList):
                self.pokeList = pokeList
                await view?.showPokeList(species: pokeList)
            case .failure(let error):
                let alert = Alert(message: error.userMessage)
                await view?.showAlert(alert: alert)
            }
        }
    }

    func didSelectPoke(at index: Int) {
        guard pokeList.indices.contains(index) else {
            return
        }

        let poke = pokeList[index].url
        router.navigate(to: .detail(poke))
    }

    func prefetchIfNeeded(for indexPaths: [IndexPath]) {
        guard !isLoadingMore, hasMorePages else {
            return
        }
        let threshold = pokeList.count - 5

        if indexPaths.contains(where: { $0.row >= threshold }) {
            isLoadingMore = true
            loadMoreData()
        }
    }

    func didTapFavorite(at indexPath: IndexPath) {
        Task {
            let pokemon = pokeList[indexPath.row]
            do {
                let isFavorite = try interactor.toggleFavorite(for: pokemon)
                await view?.updateFavoriteStatus(at: indexPath, isFavorite: isFavorite)
            } catch {
                let alert = Alert(message: NetworkError.fileNotFound.userMessage)
                await view?.showAlert(alert: alert)
            }
        }
    }

    func isFavorite(at id: String) -> Bool {
        interactor.isFavorite(id)
    }

    private func loadMoreData() {
        Task {
            await view?.showLoading(isLoading: true)
            let result = await interactor.fetchMoreData()

            await view?.showLoading(isLoading: false)
            isLoadingMore = false
            hasMorePages = true

            switch result {
            case .success(let pokeList):
                self.pokeList.append(contentsOf: pokeList)
                await view?.showPokeList(species: self.pokeList)
            case .failure(let error):
                let alert = Alert(message: error.userMessage)
                await view?.showAlert(alert: alert)
            }
        }
    }
}
