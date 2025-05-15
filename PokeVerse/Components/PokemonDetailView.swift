//
//  PokemonDetailView.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 15.05.2025.
//

import UIKit

final class PokemonDetailView: UIView {

    // MARK: - Constants

    enum Constants {
        static let headerImageSize: CGFloat = 200
        static let headerImageTopSpacing: CGFloat = 20
        static let headerStackSpacing: CGFloat = 8

        static let mainStackSpacing: CGFloat = 16
        static let mainStackTopSpacing: CGFloat = 16
        static let mainStackSidePadding: CGFloat = 16
        static let mainStackBottomPadding: CGFloat = 20

        static let segmentedControlHeight: CGFloat = 32
        static let separatorHeight: CGFloat = 1

        static let idLabelFontSize: CGFloat = 16
        static let nameLabelFontSize: CGFloat = 32
        static let descriptionFontSize: CGFloat = 15
    }

    // MARK: - UI Properties

    let scrollView = UIScrollView()
    let contentView = UIView()
    let headerImageView = UIImageView()
    let idLabel = UILabel()
    let nameLabel = UILabel()
    let typeLabel = PillLabel()
    let segmentedControl = UISegmentedControl()
    let descriptionLabel = UILabel()
    let mainStack = UIStackView()

    let aboutView = AboutView()
    let statsView = StatsDetailView()
    let evolutionView = EvolutionDetailView()

    private var activeConstraints: [NSLayoutConstraint] = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupConstraints()
        setupStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViewHierarchy() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerImageView)

        let headerStack = UIStackView(arrangedSubviews: [idLabel, nameLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = Constants.headerStackSpacing
        headerStack.alignment = .center

        mainStack.axis = .vertical
        mainStack.spacing = Constants.mainStackSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(typeLabel)
        mainStack.addArrangedSubview(segmentedControl)
        mainStack.addArrangedSubview(createSeparator())
        mainStack.addArrangedSubview(descriptionLabel)

        contentView.addSubview(mainStack)
    }

    private func setupConstraints() {
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints = [
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.headerImageTopSpacing),
            headerImageView.widthAnchor.constraint(equalToConstant: Constants.headerImageSize),
            headerImageView.heightAnchor.constraint(equalToConstant: Constants.headerImageSize),

            segmentedControl.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight),

            mainStack.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: Constants.mainStackTopSpacing),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.mainStackSidePadding),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.mainStackSidePadding),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.mainStackBottomPadding)
        ]
        NSLayoutConstraint.activate(activeConstraints)
    }

    private func setupStyles() {
        backgroundColor = .systemBackground
        headerImageView.contentMode = .scaleAspectFit
        idLabel.font = UIFont.monospacedDigitSystemFont(ofSize: Constants.idLabelFontSize, weight: .bold)
        idLabel.textColor = .secondaryLabel
        nameLabel.font = UIFont.systemFont(ofSize: Constants.nameLabelFontSize, weight: .heavy)
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.numberOfLines = .zero
    }

    private func createSeparator() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: Constants.separatorHeight).isActive = true
        return view
    }
}
