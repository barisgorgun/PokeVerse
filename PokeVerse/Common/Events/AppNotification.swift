//
//  AppEvents.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 26.05.2025.
//

import UIKit

enum AppNotification: String {
    case favoriteStatusChanged

    var name: Notification.Name {
        Notification.Name(rawValue)
    }
}

