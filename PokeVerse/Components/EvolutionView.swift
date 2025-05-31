//
//  EvolutionView.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

import UIKit

final class EvolutionDetailView: UIView {

    // MARK: - Constants

    enum Constants {
        static let stackSpacing: CGFloat = 16
        static let negativeStackSpacing: CGFloat = -16
        static let customStackSpacing: CGFloat = 8
        static let arrowSize: CGFloat = 14
        static let labelSize: CGFloat = 20
        static let imageViewSize: CGFloat = 80
        static let nameLabelSize: CGFloat = 16
        static let labelNumberOfLines: Int = 2
    }

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "detail_section_evolution_chain".localized()
        label.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .bold)
        return label
    }()

    private let evolutionStack = UIStackView(
        axis: .horizontal,
        spacing: Constants.arrowSize,
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.stackSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackSpacing),

            evolutionStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.labelSize),
            evolutionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackSpacing),
            evolutionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.negativeStackSpacing),
            evolutionStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.negativeStackSpacing)
        ])
    }

    // MARK: - Data Binding
    
    func configure(with pokemon: Pokemon) {
        let evolution = pokemon.evolutionDetails.chain
        evolutionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let stages = parseEvolutionChain(evolution)
        stages.forEach { stage in
                let stageView = createEvolutionStageView(
                    pokemonId: stage.id,
                    pokemonName: stage.name.capitalized,
                    method: stage.method.capitalized
                )

                evolutionStack.addArrangedSubview(stageView)
            guard stage == stages.last! else {
                addArrowView()
                return
            }
        }
    }

    // MARK: - Private funcs

    private func createEvolutionStageView(pokemonId: Int, pokemonName: String, method: String) -> UIView {
        let container = UIView()

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageCacheManager.shared.getImage(for: "\(pokemonId)")

        let nameLabel = UILabel()
        nameLabel.text = pokemonName
        nameLabel.numberOfLines = .zero
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: Constants.nameLabelSize, weight: .medium)

        let methodLabel = UILabel()
        methodLabel.text = method
        methodLabel.font = UIFont.italicSystemFont(ofSize: Constants.arrowSize)
        methodLabel.textColor = .secondaryLabel
        methodLabel.textAlignment = .center
        methodLabel.numberOfLines = Constants.labelNumberOfLines

        let stack = UIStackView(
            axis: .vertical,
            spacing: Constants.customStackSpacing,
            alignment: .center,
            arrangedSubviews: [
                imageView,
                nameLabel,
                methodLabel
            ]
        )


        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),

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
            arrow.widthAnchor.constraint(equalToConstant: Constants.arrowSize),
            arrow.heightAnchor.constraint(equalToConstant: Constants.arrowSize)
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

    private func parseEvolutionChain(_ chain: ChainLink) -> [(
        id: Int,
        name: String,
        url: String,
        method: String
    )] {
        var result = [(Int, String, String, String)]()
        var currentLink: ChainLink? = chain

        while let link = currentLink {
            let method = link.evolvesTo.first?.species.name ?? "Level Up"
            result.append((link.species.pokemonID.zeroIfNone(), link.species.name, link.species.url, method))
            currentLink = link.evolvesTo.first
        }

        return result
    }
}
