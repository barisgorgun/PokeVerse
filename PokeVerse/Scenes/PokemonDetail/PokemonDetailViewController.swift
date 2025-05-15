//
//  PokemonDetailViewController.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

final class PokemonDetailViewController: UIViewController, AlertPresentable {

    // MARK: - Constants

    enum Constants {
        static let stackSpacing: CGFloat = 16
        static let negativeStackSpacing: CGFloat = -16
        static let bottomAnchorSpacing: CGFloat = -20
        static let customStackSpacing: CGFloat = 8
        static let sectionStackSpacing: CGFloat = 12
        static let nameLabelSize: CGFloat = 32
        static let descriptionLabelSize: CGFloat = 15
        static let sectionHeaderSize: CGFloat = 20
        static let headerViewSize: CGFloat = 200
        static let segmentedControlHeight: CGFloat = 32
    }

    // MARK: - Properties

    private var pokemon: Pokemon? = nil
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var activeConstraints: [NSLayoutConstraint] = []
    private var mainStack = UIStackView(axis: .vertical, spacing: Constants.stackSpacing)

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0, 0.7]
        return gradient
    }()

    // MARK: - UI Components

    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: Constants.stackSpacing, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.nameLabelSize, weight: .heavy)
        return label
    }()

    private let typeLabel: PillLabel = {
        let label = PillLabel()
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(
            items: [
                "detail_section_about".localized(),
                "detail_section_stats".localized(),
                "detail_section_evolution".localized()
            ]
        )
        sc.selectedSegmentIndex = .zero
        sc.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return sc
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: Constants.descriptionLabelSize, weight: .medium)
        return label
    }()

    private var aboutView = AboutView()
    private var statsView = StatsDetailView()
    private var evolutionView = EvolutionDetailView()

    private let pokeDetailPresenter: PokemonDetailPresenterProtocol

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        pokeDetailPresenter.loadData()
        view.layer.insertSublayer(gradientLayer, at: .zero)
    }

    init(pokeDetailPresenter: PokemonDetailPresenter) {
        self.pokeDetailPresenter = pokeDetailPresenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // TODO: Bunun için çözüm bul

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(headerImageView)

        let headerStack = UIStackView(
            axis: .horizontal,
            spacing: Constants.customStackSpacing,
            alignment: .center,
            arrangedSubviews: [idLabel, nameLabel]
        )

        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(typeLabel)
        mainStack.addArrangedSubview(segmentedControl)
        mainStack.addArrangedSubview(createSeparator())
        mainStack.addArrangedSubview(descriptionLabel)
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)
    }


    private func setupConstraints() {
        NSLayoutConstraint.deactivate(activeConstraints)

        activeConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.sectionHeaderSize),
            headerImageView.widthAnchor.constraint(equalToConstant: Constants.headerViewSize),
            headerImageView.heightAnchor.constraint(equalToConstant: Constants.headerViewSize),

            segmentedControl.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight),

            mainStack.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: Constants.stackSpacing),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.stackSpacing),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.negativeStackSpacing),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.bottomAnchorSpacing)
        ]

        NSLayoutConstraint.activate(activeConstraints)
    }


    private func updateUI() {
        guard let pokemon else {
            return
        }
        idLabel.text = "#\(String(format: "%03d", pokemon.speciesDetail.id))"
        nameLabel.text = pokemon.speciesDetail.name.capitalized
        typeLabel.text = pokemon.speciesDetail.getLocalizedGenus()
        typeLabel.backgroundColor = PokemonTypeColor.color(for: pokemon.speciesDetail.color.name).withAlphaComponent(0.2)
        typeLabel.textColor = PokemonTypeColor.color(for: pokemon.speciesDetail.color.name)
        descriptionLabel.text = pokemon.speciesDetail.getLatestFlavorText()
        headerImageView.kf.setImage(with: pokemon.evolutionDetails.chain.species.imageURL)
        gradientLayer.colors = [PokemonTypeColor.color(for: pokemon.speciesDetail.color.name).cgColor, UIColor.systemBackground.cgColor]
    }
}

// MARK: Private funcs

private extension PokemonDetailViewController {

    func createSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }

    func setupInfoViews(pokemon: Pokemon) {
        aboutView.configure(pokemon: pokemon)
        statsView.configure(with: pokemon.pokemonDetails)
        evolutionView.configure(with: pokemon)

        mainStack.addArrangedSubview(self.aboutView)
        mainStack.addArrangedSubview(self.statsView)
        mainStack.addArrangedSubview(self.evolutionView)
        statsView.isHidden = true
        evolutionView.isHidden = true
    }

    func showAboutView() {
        aboutView.isHidden = false
        statsView.isHidden = true
        evolutionView.isHidden = true
    }

    func showEvolutionView() {
        aboutView.isHidden = true
        statsView.isHidden = true
        evolutionView.isHidden = false
    }

    func showStatsView() {
        aboutView.isHidden = true
        statsView.isHidden = false
        evolutionView.isHidden = true
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        pokeDetailPresenter.selectedControllerTapped(at: sender.selectedSegmentIndex)
    }
}

// MARK: PokemonDetailViewProtocol

extension PokemonDetailViewController: PokemonDetailViewProtocol {

    func handleOutput(_ output: PokemonDetailPresenterOutput) {
        switch output {
        case .setLoading(let isLoading):
            DispatchQueue.main.async {
                self.navigationController?.view.setLoading(isLoading)
            }
        case .showAlert(let alert):
            show(alert: alert)
        case .showData(let pokemon):
            self.pokemon = pokemon
            DispatchQueue.main.async {
                self.updateUI()
                self.setupInfoViews(pokemon: pokemon)
            }
        case .showInfoView(let detailViewType):
            switch detailViewType {
            case .about:
                showAboutView()
            case .evolution:
                showEvolutionView()
            case .stats:
                showStatsView()
            }
        }
    }
}
