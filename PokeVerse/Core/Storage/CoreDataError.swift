//
//  CoreDataError.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import Foundation

enum CoreDataError: Error {
    case saveError(Error)
    case fetchError(Error)
    case duplicateEntry
    case invalidData
    case itemNotFound
    case contextNotAvailable
    case unknownError(Error)

    var localizedDescription: String {
        switch self {
        case .saveError:
            "error_save_failed".localized()
        case .fetchError:
            "error_fetch_failed".localized()
        case .duplicateEntry:
            "error_duplicate_favorite".localized()
        case .invalidData:
            "error_invalid_data".localized()
        case .itemNotFound:
            "error_item_not_found".localized()
        case .contextNotAvailable:
            "error_context_unavailable".localized()
        case .unknownError:
            "error_unknown".localized()
        }
    }
}
