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

    enum Constants {
        static let cellHeight: CGFloat = 80
        static let footerHeight: CGFloat = 70
        static let footherViewHeight: CGFloat = 60
    }

    // MARK: - Properties

    private let pokeListPresenter: PokeListPresenterProtocol!
    private var pokeList: [Species] = []
    private var imageMap: [String: UIImage] = [:]
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
    
    // TODO: Bunun için çözüm bul
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: Private Funcs

private extension PokeListViewController {

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func makeLoadMoreFooterView() -> UIView {
        let footerView = LoadMoreFooterView()
        footerView.frame = CGRect(
            x: .zero,
            y: .zero,
            width: tableView.bounds.width,
            height: Constants.footherViewHeight
        )

        footerView.onTap = { [weak self] in
            self?.pokeListPresenter.loadMoreData()
        }
        return footerView
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

// MARK: - PokeListViewProtocol

extension PokeListViewController: PokeListViewProtocol {

    func handleOutput(_ output: PokeListPresenterOutput) {
        switch output {
        case .showPokeList(let pokeList):
            self.pokeList.append(contentsOf: pokeList)
            self.tableView.reloadData()
        case .setLoading(let isLoading):
            DispatchQueue.main.async {
                self.navigationController?.view.setLoading(isLoading)
            }
        case .showAlert(let alert):
            show(alert: alert, style: .alert)
        case .showLoadMore:
            tableView.tableFooterView = makeLoadMoreFooterView()
        }
    }
}
