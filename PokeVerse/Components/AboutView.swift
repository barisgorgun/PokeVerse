//
//  AboutView.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

import UIKit

final class AboutView: UIView {

    // MARK: - Constants

    enum Constants {
        static let stackSpacing: CGFloat = 16
        static let negativeStackSpacing: CGFloat = -16
        static let customStackSpacing: CGFloat = 8
        static let sectionStackSpacing: CGFloat = 12
        static let labelSize: CGFloat = 20
        static let alphaValue: CGFloat = 0.1
    }

    private var pokemon: SpeciesDetail?
    private var pokemonDetails: PokemonDetails?

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = Constants.stackSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addSubview(stackView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.stackSpacing),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackSpacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.negativeStackSpacing),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: Constants.negativeStackSpacing)
        ])
    }

    // MARK: - Configure

    func configure(pokemon: Pokemon) {
        self.pokemon = pokemon.speciesDetail
        self.pokemonDetails = pokemon.pokemonDetails
        stackView.addArrangedSubview(createStatsSection())
        stackView.addArrangedSubview(createEggGroupsSection())
    }

    // MARK: - Section Builders

    private func createStatsSection() -> UIView {
        guard let pokemon else { return UIView() }

        let stack = UIStackView(axis: .vertical, spacing: Constants.sectionStackSpacing)

        let titleLabel = UILabel()
        titleLabel.text = "detail_section_details".localized()
        titleLabel.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .bold)

        guard let pokemonDetails else {
            return UIView()
        }

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(createStatRow(title: "detail_header_capture_rate".localized(), value: "\(pokemon.captureRate.zeroIfNone())"))
        stack.addArrangedSubview(createStatRow(title: "detail_header_base_happiness".localized(), value: "\(pokemon.baseHappiness.zeroIfNone())"))
        stack.addArrangedSubview(createStatRow(title: "detail_header_weight".localized(), value: "\(pokemonDetails.weight.zeroIfNone())"))
        stack.addArrangedSubview(createStatRow(title: "detail_header_height".localized(), value: "\(pokemonDetails.height.zeroIfNone())"))
        stack.addArrangedSubview(createStatRow(title: "detail_header_type".localized(), value: "\((pokemonDetails.types?.first?.type?.name).emptyIfNone())"))

        return stack
    }

    private func createStatRow(title: String, value: String) -> UIStackView {
        let stack = UIStackView(axis: .horizontal)
        stack.distribution = .fill

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textAlignment = .right

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)

        return stack
    }

    private func createEggGroupsSection() -> UIView {
        guard let pokemon, !pokemon.eggGroups.isEmpty else { return UIView() }

        let stack = UIStackView(axis: .vertical, spacing: Constants.customStackSpacing)

        let titleLabel = UILabel()
        titleLabel.text = "detail_header_egg_groups".localized()
        titleLabel.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .bold)

        let groupsStack = UIStackView(axis: .horizontal, spacing: Constants.customStackSpacing)

        pokemon.eggGroups.forEach { group in
            let pill = PillLabel()
            pill.text = group.name.capitalized
            pill.backgroundColor = .systemBlue.withAlphaComponent(Constants.alphaValue)
            pill.textColor = .systemBlue
            groupsStack.addArrangedSubview(pill)
        }

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(groupsStack)

        return stack
    }
}
