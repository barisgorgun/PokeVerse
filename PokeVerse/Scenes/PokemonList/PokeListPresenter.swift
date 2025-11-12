//
//  PokeListPresenter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import Foundation
import CoreNetwork
import Core

final class PokeListPresenter: PokeListPresenterProtocol {

    // MARK: - Properties

    weak var view: PokeListViewProtocol?
    private let interactor: PokeListInteractorProtocol
    private let router: PokeListRouterProtocol
    private let analytics: AnalyticsTracking
    private var isLoadingMore = false
    private var hasMorePages = true

#if DEBUG
    var pokeList: [PokemonDisplayItem] = []
#else
    private(set) var pokeList: [PokemonDisplayItem] = []
#endif
    
    init(
        view: PokeListViewProtocol?,
        interactor: PokeListInteractorProtocol,
        router: PokeListRouterProtocol,
        analytics: AnalyticsTracking
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
    }

    func load() async {
        await view?.showLoading(isLoading: true)
        let result = await interactor.fetchData()
        await view?.showLoading(isLoading: false)

        switch result {
        case .success(let pokeList):
            self.pokeList = pokeList
            await view?.showPokeList(species: pokeList)
            analytics.logEvent(.screenView(name: "PokeList"))
        case .failure(let error):
            let alert = Alert(message: error.userMessage)
            await view?.showAlert(alert: alert)
        }
    }

    func didSelectPoke(at index: Int) {
        guard pokeList.indices.contains(index) else {
            return
        }

        let poke = pokeList[index].url
        router.navigate(to: .detail(poke))
        analytics.logEvent(.buttonTap(name: "SelectPoke"))
    }

    func prefetchIfNeeded(for indexPaths: [IndexPath]) async {
        guard !isLoadingMore, hasMorePages else {
            return
        }
        let threshold = pokeList.count - 5

        if indexPaths.contains(where: { $0.row >= threshold }) {
            isLoadingMore = true
            await loadMoreData()
        }
    }

    func didTapFavorite(at indexPath: IndexPath) async {
        guard pokeList.indices.contains(indexPath.row) else {
            return
        }
        let pokemon = pokeList[indexPath.row]
        do {
            let isFavorite = try interactor.toggleFavorite(for: pokemon)
            pokeList[indexPath.row].isFavorite = isFavorite
            await view?.updateFavoriteStatus(at: indexPath, isFavorite: isFavorite)
            EventCenter.post(.favoriteStatusChanged, userInfo: ["id": pokemon.id, "isFavorite": pokemon.isFavorite])
            analytics.logEvent(.buttonTap(name: "Favorite"))
        } catch let error as CoreDataError {
            let alert = Alert(message: error.localizedDescription)
            await view?.showAlert(alert: alert)
        } catch {
            let alert = Alert(message: "error_unexpected_message".localized())
            await view?.showAlert(alert: alert)
        }
    }

    func isFavorite(at id: String) -> Bool {
        interactor.isFavorite(id)
    }

    private func loadMoreData() async {
        await view?.showLoading(isLoading: true)
        let result = await interactor.fetchMoreData()

        await view?.showLoading(isLoading: false)
        isLoadingMore = false
        hasMorePages = true

        switch result {
        case .success(let pokeList):
            self.pokeList.append(contentsOf: pokeList)
            await view?.showPokeList(species: self.pokeList)
            analytics.logEvent(.prefetchSuccess(count: pokeList.count))
        case .failure(let error):
            let alert = Alert(message: error.userMessage)
            await view?.showAlert(alert: alert)
            analytics.logEvent(.prefetchFailed)
        }
    }

    func didReceiveFavoriteRemoval(for id: String) async {
        guard let index = pokeList.firstIndex(where: { $0.id == id }) else {
            return
        }
        pokeList[index].isFavorite = false
        await view?.updateFavoriteStatus(at: IndexPath(row: index, section: 0), isFavorite: false)
    }
}
