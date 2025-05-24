//
//  FavoriteListViewController.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import UIKit

class FavoriteListViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellHeight: CGFloat = 100
    }

    private lazy var favoriteListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        return tableView
    }()

    private var favoriteList: [PokemonDisplayItem] = []
    private let favoriteListPresenter: FavoriteListPresenterProtocol

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteListPresenter.load()
        
        favoriteListTableView.dataSource = self
        favoriteListTableView.delegate = self
        view.addSubview(favoriteListTableView)

        NSLayoutConstraint.activate([
            favoriteListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        title = "Favoriler"
    }

    init(favoriteListPresenter: FavoriteListPresenterProtocol) {
        self.favoriteListPresenter = favoriteListPresenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension FavoriteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }

        cell.configure(species: favoriteList[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
}

// MARK: - FavoriteListViewProtocol

extension FavoriteListViewController: FavoriteListViewProtocol {

    func reloadData(with species: [PokemonDisplayItem]) {
        favoriteList = species
        favoriteListTableView.reloadData()
    }
}

// MARK: - PokemonListCellDelegate

extension FavoriteListViewController: PokemonListCellDelegate {

    func didTapFavoriteButton(on cell: PokemonCell) {
        guard let indexPath = favoriteListTableView.indexPath(for: cell) else {
            return
        }
        favoriteListPresenter.didTapFavorite(at: indexPath)
    }
}
