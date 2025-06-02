//
//  MainTabBarController.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 23.05.2025.
//

import UIKit
import FirebaseAnalytics

class MainTabBarController: UITabBarController {
    private let analytics: AnalyticsTracking

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemRed
        tabBar.backgroundColor = .systemBackground
    }

    init(analytics: AnalyticsTracking) {
        self.analytics = analytics
        super.init(nibName: nil, bundle: nil)
        setupTabs()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabs() {
        let pokeListVC = PokeListBuilder.build(analytics: analytics)
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

