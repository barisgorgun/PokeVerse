//
//  UIStackView+Extension.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 11.05.2025.
//

import UIKit

extension UIStackView {

    convenience init(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = .zero,
        alignment: UIStackView.Alignment = .fill,
        arrangedSubviews: [UIView] = []
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
    }
}
