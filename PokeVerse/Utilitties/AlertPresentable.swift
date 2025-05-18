//
//  AlertPresentable.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 18.05.2025.
//

import UIKit

protocol AlertPresentable where Self: UIViewController {
    func show(alert: Alert, style: UIAlertController.Style)
}

extension AlertPresentable {
    func show(alert: Alert, style: UIAlertController.Style = .alert) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: alert.title,
                message: alert.message,
                preferredStyle: style
            )

            if let tintColor = alert.tintColor {
                alertController.view.tintColor = tintColor
            }

            alert.actions.forEach { action in
                let uiAction = UIAlertAction(
                    title: action.title,
                    style: action.style.toUIAlertActionStyle(),
                    handler: nil
                )
                alertController.addAction(uiAction)
            }

            self.present(alertController, animated: true)
        }
    }
}

// MARK: - AlertAction Style

extension AlertAction.Style {

    func toUIAlertActionStyle() -> UIAlertAction.Style {
        switch self {
        case .default:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}
