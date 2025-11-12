//
//  ViewState.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

enum ViewState<T: Equatable>: Equatable {
    case idle
    case loading
    case success(T)
    case error(String)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var data: T? {
        if case .success(let data) = self { return data }
        return nil
    }

    var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }
}
