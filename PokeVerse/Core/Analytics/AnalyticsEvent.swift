//
//  AnalyticsEvent.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.06.2025.
//

enum AnalyticsEvent {
    case screenView(name: String)
    case buttonTap(name: String)
    case custom(name: String, parameters: [String: Any]?)
    case prefetchTriggered(index: Int)
    case prefetchSuccess(count: Int)
    case prefetchFailed

    var name: String {
        switch self {
        case .screenView:
            "screen_view"
        case .buttonTap:
            "button_tap"
        case .custom(let name, _):
            name
        case .prefetchTriggered:
            "prefetch_triggered"
        case .prefetchSuccess:
            "prefetch_success"
        case .prefetchFailed:
            "prefetch_failed"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .screenView(let name):
            ["screen_name": name]
        case .buttonTap(let name):
            ["button_name": name]
        case .custom(_, let parameters):
            parameters
        case .prefetchTriggered(let index):
            ["start_index": index]
        case .prefetchSuccess(let count):
            ["loaded_count": count]
        case .prefetchFailed:
            nil
        }
    }
}
