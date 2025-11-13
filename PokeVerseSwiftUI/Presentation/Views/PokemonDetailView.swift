//
//  PokemonDetailView.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import SwiftUI
import CoreNetwork

struct PokemonDetailView: View {
    @StateObject var vm: PokemonDetailViewModel
    @EnvironmentObject var favorites: FavoriteListViewModel

    let pokemonName: String
    let pokemonImage: UIImage

    init(pokemonUrl: String, pokemonName: String, pokemonImage: UIImage) {
        self.pokemonName = pokemonName
        self.pokemonImage = pokemonImage

        _vm = StateObject(wrappedValue:
            PokemonDetailViewModel(
                pokemonDetailService: PokemonDetailService(),
                pokemonUrl: pokemonUrl,
                favorites: FavoriteListViewModel()
            )
        )
    }

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            content
        }
        .navigationTitle(pokemonName.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.setFavorites(favorites)
        }
        .task {
            await vm.fetchData()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            LoadingView(title: "Loading Pokémon...")
        case .error(let message):
            ErrorView(message: message) {
                Task { await vm.fetchData() }
            }
        case .success(let pokemon):
            ScrollView {
                VStack(spacing: 16) {
                    HeaderSection(
                        pokemonImage: pokemonImage,
                        pokemonName: pokemonName,
                        pokemon: pokemon
                    )
                    .environmentObject(favorites)
                    InfoSection(pokemon: pokemon)
                    EvolutionSection(pokemon: pokemon)
                }
                .padding()
            }
        }
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.blue.opacity(0.2), .purple.opacity(0.25)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    PokemonDetailView(
        pokemonUrl: "https://pokeapi.co/api/v2/pokemon/1",
        pokemonName: "bulbasaur",
        pokemonImage: UIImage(systemName: "leaf") ?? UIImage()
    )
}
