//
//  PokemonCell.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 7.05.2025.
//

import UIKit

final class PokemonCell: UITableViewCell {
    static let identifier = "PokemonCell"

    enum Constants {
        static let imageSize: CGFloat = 80
        static let imageLeading: CGFloat = 16
        static let trailingSpacing: CGFloat = -16
        static let imageViewSize: CGFloat = 60
        static let leadingSpacing: CGFloat = 16
        static let labelFontSize: CGFloat = 18
    }

    private var pokeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(pokeImageView)
        contentView.addSubview(nameLabel)

        pokeImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pokeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingSpacing),
            pokeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokeImageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            pokeImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize),

            nameLabel.leadingAnchor.constraint(equalTo: pokeImageView.trailingAnchor, constant: Constants.leadingSpacing),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingSpacing)
        ])

        pokeImageView.contentMode = .scaleAspectFit
        nameLabel.font = UIFont.systemFont(ofSize: Constants.labelFontSize, weight: .medium)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(species: Species) {
        nameLabel.text = species.name
        pokeImageView.contentMode = .scaleAspectFit
        pokeImageView.kf.setImage(with: species.imageURL)
    }
}

