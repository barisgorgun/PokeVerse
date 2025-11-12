//
//  PokeListView.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 11.11.2025.
//

import SwiftUI
import CoreNetwork

struct PokeListView: View {
    @StateObject private var vm = PokeListViewModel(pokeListService: PokemonListService())
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()
                content
            }
            .navigationTitle("Pokémon List")
            .navigationDestination(item: $vm.selectedPokemon) { selected in
                PokemonDetailView(
                    pokemonUrl: selected.url,
                    pokemonName: selected.name,
                    pokemonImage: selected.image
                )
            }
            .task {
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
                            toggleFavorite: { vm.toggleFavorite(for: pokemon) },
                            onTap: { vm.selectedPokemon = pokemon }
                        )
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
}
