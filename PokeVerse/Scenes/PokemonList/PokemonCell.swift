//
//  PokemonCell.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import UIKit
import CoreNetwork

protocol PokemonListCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: PokemonCell)
}

final class PokemonCell: UITableViewCell {
    static let identifier = "PokemonCell"

    weak var delegate: PokemonListCellDelegate?

    private enum Constants {
        static let imageLeading: CGFloat = 16
        static let trailingSpacing: CGFloat = -16
        static let imageViewSize: CGFloat = 90
        static let leadingSpacing: CGFloat = 30
        static let labelFontSize: CGFloat = 24
        static let buttonSize: CGFloat = 32
    }

    private lazy var pokeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .red
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(pokeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)

        pokeImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pokeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingSpacing),
            pokeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokeImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            pokeImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),

            nameLabel.leadingAnchor.constraint(equalTo: pokeImageView.trailingAnchor, constant: Constants.leadingSpacing),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            favoriteButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingSpacing),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
        ])

        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        pokeImageView.contentMode = .scaleAspectFit
        nameLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize, weight: .bold)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func favoriteTapped() {
        delegate?.didTapFavoriteButton(on: self)
    }

    func configure(species: PokemonDisplayItem) {
        nameLabel.text = species.name
        pokeImageView.image = species.image

        let heartImage = species.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: heartImage), for: .normal)
        favoriteButton.tintColor = species.isFavorite ? .systemRed : .gray
    }
}

