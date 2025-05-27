//
//  MainTabBarController.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 23.05.2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        tabBar.tintColor = .systemRed
        tabBar.backgroundColor = .systemBackground
    }

    private func setupTabs() {
        let pokeListVC = PokeListBuilder.build()
        let listNav = UINavigationController(rootViewController: pokeListVC)
        listNav.tabBarItem = UITabBarItem(title: "pokeList_title".localized(), image: UIImage(systemName: "list.bullet"), tag: 0)
        listNav.navigationBar.prefersLargeTitles = true
        listNav.applyDefaultAppearance()

        let favoriteVC = FavoriteListBuilder.build()
        let favoriteNav = UINavigationController(rootViewController: favoriteVC)
        favoriteNav.tabBarItem = UITabBarItem(title: "favorite_title".localized(), image: UIImage(systemName: "star.fill"), tag: 1)
        favoriteNav.navigationBar.prefersLargeTitles = true
        favoriteNav.applyDefaultAppearance()

        viewControllers = [listNav, favoriteNav]
    }
}

