//
//  StatsDetailView.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

import UIKit

final class StatsDetailView: UIView {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "detail_section_stats".localized()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let statsStack = UIStackView(axis: .vertical, spacing: 12)

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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            statsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            statsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
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
        let row = UIStackView(axis: .horizontal, spacing: 12, alignment: .center)
        row.distribution = .fill

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textColor = .secondaryLabel
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true

        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = Float(value) / 10
        progressView.tintColor = PokemonTypeColor.progressColor(for: value)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true

        let valueLabel = UILabel()
        valueLabel.text = "\(value)"
        valueLabel.textAlignment = .right
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        valueLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        row.addArrangedSubview(nameLabel)
        row.addArrangedSubview(progressView)
        row.addArrangedSubview(valueLabel)

        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 8),
            progressView.widthAnchor.constraint(equalToConstant: 100)
        ])

        return row
    }
}
