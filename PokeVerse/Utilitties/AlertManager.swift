//
//  AlertManager.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

struct Alert {
    let title: String?
    let messsage: String?
    let tintColor: UIColor?
    let actions: [UIAlertAction]

    init(
        title: String? = "error_2".localized(),
        messsage: String?,
        tintColor: UIColor? = .none,
        actions: [UIAlertAction]? = nil
    ) {
        self.title = title
        self.messsage = messsage
        self.tintColor = tintColor

        if let actions, !actions.isEmpty {
            self.actions = actions
        } else {
            let defaultAction = UIAlertAction(
                title: "action_1".localized(),
                style: .default,
                handler: nil
            )
            self.actions = [defaultAction]
        }
    }
}

protocol AlertPresentable where Self: UIViewController {
    func show(alert: Alert, style: UIAlertController.Style)
}


extension AlertPresentable {

    func show(alert: Alert, style: UIAlertController.Style = .alert) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: alert.title,
                message: alert.messsage,
                preferredStyle: style
            )

            if let tintColor = alert.tintColor {
                alertController.view.tintColor = tintColor
            }

            alert.actions.forEach { alertController.addAction($0) }

            self.present(alertController, animated: true)
        }
    }
}
