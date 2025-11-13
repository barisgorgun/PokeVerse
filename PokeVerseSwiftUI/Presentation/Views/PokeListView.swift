//
//  PokeListView.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 11.11.2025.
//

import SwiftUI
import CoreNetwork
import Core

struct PokeListView: View {

    @EnvironmentObject var favorites: FavoriteListViewModel
    @StateObject private var vm: PokeListViewModel

    init() {
        _vm = StateObject(wrappedValue:
            PokeListViewModel(
                pokeListService: PokemonListService(),
                dataStore: FavoritePokemonDataStore(),
                favorites: nil
            )
        )
    }

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()
                content
            }
            .navigationTitle("Pokémon List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoriteListView()) {
                        Image(systemName: "star.fill")
                    }
                }
            }
            .navigationDestination(item: $vm.selectedPokemon) { selected in
                PokemonDetailView(
                    pokemonUrl: selected.url,
                    pokemonName: selected.name,
                    pokemonImage: selected.image
                )
                .environmentObject(favorites)
            }
            .task {
                vm.setFavorites(favorites)
                await vm.loadPokemons()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            LoadingView(title: "Loading Pokémon...")
        case .error(let message):
            ErrorView(message: message) {
                Task { await vm.loadPokemons() }
            }
        case .success(let pokemons):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(pokemons, id: \.id) { pokemon in
                        PokemonCardView(
                            item: pokemon,
                            onTap: { vm.selectedPokemon = pokemon }
                        )
                        .environmentObject(favorites)
                    }
                }
                .padding()
            }
            .transition(.opacity.combined(with: .scale))
        }
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.blue.opacity(0.2), .purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    PokeListView()
        .environmentObject(FavoriteListViewModel())
}
