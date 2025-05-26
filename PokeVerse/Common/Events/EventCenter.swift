//
//  EventCenter.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 26.05.2025.
//

import Foundation

final class EventCenter {
    
    static func post(_ notification: AppNotification, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: notification.name, object: nil, userInfo: userInfo)
    }

    static func observe(_ observer: Any, selector: Selector, for notification: AppNotification) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notification.name, object: nil)
    }

    static func remove(_ observer: Any, for notification: AppNotification) {
        NotificationCenter.default.removeObserver(observer, name: notification.name, object: nil)
    }
}

