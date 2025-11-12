//
//  FirebaseAnalyticsManager.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.06.2025.
//

import FirebaseAnalytics

protocol AnalyticsTracking {
    func logEvent(_ event: AnalyticsEvent)
}

final class FirebaseAnalyticsManager: AnalyticsTracking {

    init() {
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setSessionTimeoutInterval(10)
    }

    func logEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}
