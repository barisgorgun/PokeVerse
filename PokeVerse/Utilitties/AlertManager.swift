//
//  AlertManager.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

struct Alert: Equatable {
    let title: String?
    let message: String?
    let tintColor: UIColor?
    let actions: [AlertAction]

    init(
        title: String? = "error_2".localized(),
        message: String?,
        tintColor: UIColor? = .none,
        actions: [AlertAction]? = nil
    ) {
        self.title = title
        self.message = message
        self.tintColor = tintColor

        if let actions, !actions.isEmpty {
            self.actions = actions
        } else {
            self.actions = [
                AlertAction(title: "action_1".localized())
            ]
        }
    }
}

struct AlertAction: Equatable {
    let title: String
    let style: Style

    enum Style: Equatable {
        case `default`
        case cancel
        case destructive
    }

    init(title: String, style: Style = .default) {
        self.title = title
        self.style = style
    }
}
