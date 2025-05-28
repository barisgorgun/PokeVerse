//
//  PokeListViewController.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import UIKit

final class PokeListViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let cellHeight: CGFloat = 100
        static let footerHeight: CGFloat = 70
        static let footherViewHeight: CGFloat = 60
    }

    // MARK: - Properties

    private let pokeListPresenter: PokeListPresenterProtocol!
    private var pokeList: [PokemonDisplayItem] = []
    private let tableView = UITableView()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "pokeList_title".localized()
        setupTableView()
        EventCenter.observe(self, selector: #selector(handleFavoriteRemoved), for: .favoriteStatusChanged)
        Task {
            await pokeListPresenter.load()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.applyDefaultAppearance()
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    init(pokeListPresenter: PokeListPresenterProtocol) {
        self.pokeListPresenter = pokeListPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handleFavoriteRemoved(notification: Notification) {
        guard let id = notification.userInfo?["id"] as? String else {
            return
        }
        Task {
            await pokeListPresenter?.didReceiveFavoriteRemoval(for: id)
        }
    }
}

// MARK: - Private Funcs

private extension PokeListViewController {

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - PokeListViewProtocol

extension PokeListViewController: PokeListViewProtocol {

    func updateFavoriteStatus(at indexPath: IndexPath, isFavorite: Bool) {
        guard pokeList.indices.contains(indexPath.row) else {
            return
        }
        pokeList[indexPath.row].isFavorite = isFavorite
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func showPokeList(species: [PokemonDisplayItem]) {
        self.pokeList = species
        tableView.reloadData()
    }

    func showAlert(alert: Alert) {
        show(alert: alert, style: .alert)
    }

    func showLoading(isLoading: Bool) {
        navigationController?.view.setLoading(isLoading)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension PokeListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }

        var species = pokeList[indexPath.row]
        species.isFavorite = pokeListPresenter.isFavorite(at: species.id)
        cell.configure(species: species)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokeListPresenter.didSelectPoke(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        Constants.footerHeight
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension PokeListViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        Task {
            await  pokeListPresenter.prefetchIfNeeded(for: indexPaths)
        }
    }
}

// MARK: - PokemonListCellDelegate

extension PokeListViewController: PokemonListCellDelegate {

    func didTapFavoriteButton(on cell: PokemonCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        Task {
            await pokeListPresenter.didTapFavorite(at: indexPath)
        }
    }
}
