//
//  FavoriteListPresenter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import Foundation

final class FavoriteListPresenter: FavoriteListPresenterProtocol {
    weak var view: FavoriteListViewProtocol?
    private let interactor: FavoriteListInteractorProtocol
    private var favoriteList: [PokemonDisplayItem] = []

    init(view: FavoriteListViewProtocol?, interactor: FavoriteListInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }


    func load() {
        favoriteList = interactor.getFavoriteList()

        Task {
            await view?.reloadData(with: favoriteList)
        }
    }

    func didTapFavorite(at indexPath: IndexPath) {
        let item = favoriteList[indexPath.row]
        do {
            try interactor.removeFavoriteItem(withName: item.id)
            Task {
                favoriteList.remove(at: indexPath.row)
                await view?.reloadData(with: favoriteList)
            }
        } catch {

        }
    }
}
