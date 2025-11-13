//
//  FavoriteList.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 13.11.2025.
//

import SwiftUI
import CoreNetwork

struct FavoriteListView: View {

    @EnvironmentObject var vm: FavoriteListViewModel
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            content
        }
        .navigationTitle("Favorites")
        .navigationDestination(item: $vm.selectedPokemon) { selected in
            PokemonDetailView(
                pokemonUrl: selected.url,
                pokemonName: selected.name,
                pokemonImage: selected.image
            )
        }
        .task {
            await vm.loadFavorites()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            LoadingView(title: "Loading Pokémon...")
        case .error(let message):
            ErrorView(message: message) {
                Task {
                    await vm.loadFavorites()
                }
            }
        case .success(let pokemons):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(pokemons, id: \.id) { pokemon in
                        PokemonCardView(
                            item: pokemon,
                            onTap: { vm.selectedPokemon = pokemon}
                        ).environmentObject(vm)
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
    FavoriteListView()
}
