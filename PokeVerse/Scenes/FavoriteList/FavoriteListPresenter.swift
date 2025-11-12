//
//  FavoriteListPresenter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import Foundation
import CoreNetwork
import Core

final class FavoriteListPresenter: FavoriteListPresenterProtocol {
    weak var view: FavoriteListViewProtocol?
    private let interactor: FavoriteListInteractorProtocol
    private var favoriteList: [PokemonDisplayItem] = []
    private let router: FavoriteListRouterProtocol

    init(
        view: FavoriteListViewProtocol?,
        interactor: FavoriteListInteractorProtocol,
        router: FavoriteListRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func load() async {
        await view?.showLoading(isLoading: true)
        favoriteList = await interactor.getFavoriteList()
        await view?.reloadData(with: favoriteList)
        await view?.showLoading(isLoading: false)
    }

    func didSelectPoke(at index: Int) {
        guard favoriteList.indices.contains(index) else {
            return
        }

        let poke = favoriteList[index].url
        router.navigate(to: .detail(poke))
    }

    func didTapFavorite(at indexPath: IndexPath) async {
        let item = favoriteList[indexPath.row]
        do {
            try interactor.removeFavoriteItem(withName: item.id)
            favoriteList.remove(at: indexPath.row)
            await view?.reloadData(with: favoriteList)
            EventCenter.post(.favoriteStatusChanged, userInfo: ["id": item.id, "isFavorite": item.isFavorite])
        } catch let error as CoreDataError {
            let alert = Alert(message: error.localizedDescription)
            await view?.showAlert(alert: alert)
        } catch {
            let alert = Alert(message: "error_unexpected_message".localized())
            await view?.showAlert(alert: alert)
        }
    }

    func didReceiveFavoriteChange() async {
        let updatedFavorites = await interactor.getFavoriteList()
        await view?.reloadData(with: updatedFavorites)
    }
}
