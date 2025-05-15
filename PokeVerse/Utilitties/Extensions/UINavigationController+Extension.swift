//
//  UINavigationController+Extension.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

extension UINavigationController {

    func applyDefaultAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    func applyTransparentAppearance(titleColor: UIColor = .black) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: titleColor]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}
