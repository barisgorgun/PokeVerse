//
//  SplashViewController.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 20.05.2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    var onAnimationFinished: (() -> Void)?

    private let animationView: LottieAnimationView = {
        let anim = LottieAnimationView(name: "pokeball")
        anim.translatesAutoresizingMaskIntoConstraints = false
        anim.contentMode = .scaleAspectFit
        anim.loopMode = .playOnce
        return anim
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAnimation()
    }

    private func setupAnimation() {
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 300)
        ])

        animationView.play { [weak self] finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.onAnimationFinished?()
                }
            }
        }
    }
}

