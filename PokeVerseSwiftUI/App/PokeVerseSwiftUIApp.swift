//
//  PokeVerseSwiftUIApp.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 11.11.2025.
//

import SwiftUI
import CoreNetwork

@main
struct PokeVerseSwiftUIApp: App {
    @StateObject private var favorites = FavoriteListViewModel()

    var body: some Scene {
        WindowGroup {
            PokeListView()
                .environmentObject(favorites)
        }
    }
}
