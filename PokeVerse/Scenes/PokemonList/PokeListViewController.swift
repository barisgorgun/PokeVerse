//
//  PokeListViewController.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import UIKit
import Kingfisher

final class PokeListViewController: UIViewController, AlertPresentable {

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
        pokeListPresenter.load()
    }

    init(pokeListPresenter: PokeListPresenterProtocol) {
        self.pokeListPresenter = pokeListPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.applyDefaultAppearance()
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
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

// MARK: - UITableViewDataSource & UITableViewDelegate

extension PokeListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }

        let species = pokeList[indexPath.row]
        cell.configure(species: species)
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
        pokeListPresenter.prefetchIfNeeded(for: indexPaths)
    }
}

// MARK: - PokeListViewProtocol

extension PokeListViewController: PokeListViewProtocol {
    
    func showPokeList(species: [PokemonDisplayItem]) {
        self.pokeList = species
        tableView.reloadData()
    }
    
    func showAlert(alert: Alert) {
        show(alert: alert, style: .alert)
    }
    
    func showLoading(isLoading: Bool) {
        self.navigationController?.view.setLoading(isLoading)
    }
}
