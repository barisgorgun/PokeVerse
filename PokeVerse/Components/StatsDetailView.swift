//
//  StatsDetailView.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

import UIKit
import CoreNetwork

final class StatsDetailView: UIView {

    // MARK: - Constants

    enum Constants {
        static let stackSpacing: CGFloat = 16
        static let negativeStackSpacing: CGFloat = -16
        static let customStackSpacing: CGFloat = 12
        static let labelSize: CGFloat = 20
        static let progressViewWidth: CGFloat = 100
        static let progressViewHeight: CGFloat = 8
        static let cornerRadius: CGFloat = 4
        static let valueLabelWidth: CGFloat = 30
        static let progressViewSize: Float = 10
    }

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "detail_section_stats".localized()
        label.font = UIFont.systemFont(ofSize: Constants.labelSize, weight: .bold)
        return label
    }()

    private let statsStack = UIStackView(axis: .vertical, spacing: Constants.customStackSpacing)

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
        addSubview(statsStack)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.stackSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackSpacing),

            statsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.labelSize),
            statsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackSpacing),
            statsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.negativeStackSpacing),
            statsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.negativeStackSpacing)
        ])
    }

    // MARK: - Data Binding
    
    func configure(with pokemon: PokemonDetails) {
        let stats = pokemon.stats
        statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        stats?.forEach { stat in
            let row = createStatRow(name: stat.stat?.name ?? "", value: stat.effort ?? .zero)
            statsStack.addArrangedSubview(row)
        }
    }

    private func createStatRow(name: String, value: Int) -> UIView {
        let row = UIStackView(axis: .horizontal, spacing: Constants.customStackSpacing, alignment: .center)
        row.distribution = .fill

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textColor = .secondaryLabel
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.numberOfLines = .zero
        nameLabel.adjustsFontSizeToFitWidth = true

        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = Float(value) / Constants.progressViewSize
        progressView.tintColor = PokemonTypeColor.progressColor(for: value)
        progressView.layer.cornerRadius = Constants.cornerRadius
        progressView.clipsToBounds = true

        let valueLabel = UILabel()
        valueLabel.text = "\(value)"
        valueLabel.textAlignment = .right
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        valueLabel.widthAnchor.constraint(equalToConstant: Constants.valueLabelWidth).isActive = true

        row.addArrangedSubview(nameLabel)
        row.addArrangedSubview(progressView)
        row.addArrangedSubview(valueLabel)

        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: Constants.progressViewHeight),
            progressView.widthAnchor.constraint(equalToConstant: Constants.progressViewWidth)
        ])

        return row
    }
}
