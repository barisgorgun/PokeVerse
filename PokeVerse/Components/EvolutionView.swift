//
//  EvolutionView.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

import UIKit
import Kingfisher

final class EvolutionDetailView: UIView {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "detail_section_evolution_chain".localized()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let evolutionStack = UIStackView(
        axis: .horizontal,
        spacing: 14,
        alignment: .center
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(evolutionStack)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        evolutionStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            evolutionStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            evolutionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            evolutionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            evolutionStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Data Binding
    
    func configure(with pokemon: Pokemon) {
        let evolution = pokemon.evolutionDetails.chain
        evolutionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let stages = parseEvolutionChain(evolution)
        stages.forEach { stage in
            if let pokemonId = extractPokemonId(from: stage.url) {
                let stageView = createEvolutionStageView(
                    pokemonId: pokemonId,
                    pokemonName: stage.name.capitalized,
                    method: stage.method.capitalized
                )
                evolutionStack.addArrangedSubview(stageView)
            }
            guard stage == stages.last! else {
                addArrowView()
                return
            }
        }
    }

    private func createEvolutionStageView(pokemonId: Int, pokemonName: String, method: String) -> UIView {
        let container = UIView()

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(
            with: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonId).png"),
            placeholder: UIImage(named: "pokemon_placeholder")
        )

        let nameLabel = UILabel()
        nameLabel.text = pokemonName
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        let methodLabel = UILabel()
        methodLabel.text = method
        methodLabel.font = UIFont.italicSystemFont(ofSize: 14)
        methodLabel.textColor = .secondaryLabel
        methodLabel.textAlignment = .center
        methodLabel.numberOfLines = 2

        let stack = UIStackView(
            axis: .vertical,
            spacing: 8,
            alignment: .center,
            arrangedSubviews: [imageView, nameLabel, methodLabel]
        )


        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    private func addArrowView() {
        let arrow = UIImageView(image: UIImage(systemName: "arrow.right"))
        arrow.tintColor = .systemGray
        arrow.contentMode = .scaleAspectFit
        evolutionStack.addArrangedSubview(arrow)

        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 14),
            arrow.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func extractPokemonId(from urlString: String) -> Int? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let components = url.pathComponents
        guard let idString = components.last(where: { $0.allSatisfy { $0.isNumber } }) else {
            return nil
        }
        return Int(idString)
    }

    private func parseEvolutionChain(_ chain: ChainLink) -> [(name: String, url: String, method: String)] {
        var result = [(String, String, String)]()
        var currentLink: ChainLink? = chain

        while let link = currentLink {
            let method = link.evolvesTo.first?.species.name ?? "Level Up"
            result.append((link.species.name, link.species.url, method))
            currentLink = link.evolvesTo.first
        }

        return result
    }
}
