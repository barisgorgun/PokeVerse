//
//  UIViewController+Loading.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

extension UIView {

    func setLoading(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                guard !self.subviews.contains(where: { $0 is LoadingView }) else {
                    return
                }

                let loadingView = LoadingView()
                self.fit(subView: loadingView)
                loadingView.startAnimating()
            } else {
                self.removeLoading()
            }
        }
    }

    func fit(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: topAnchor),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func removeLoading() {
        subviews
            .compactMap { $0 as? LoadingView }
            .forEach { $0.removeFromSuperview() }
    }
}


extension Optional {

    struct FoundNilError: Error {}

    func unwrap() throws -> Wrapped {
        switch self {
        case .some(let wrapped):
            return wrapped
        case .none:
            throw FoundNilError()
        }
    }
}

extension Optional where Wrapped == String {

    func emptyIfNone() -> String {
        self ?? ""
    }
}

extension Optional where Wrapped == Int {

    func zeroIfNone() -> Int {
        self ?? .zero
    }
}
