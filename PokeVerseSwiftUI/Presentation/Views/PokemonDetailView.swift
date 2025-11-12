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
    let pokemonUrl: String
    let pokemonName: String
    let pokemonImage: UIImage

    init(pokemonUrl: String, pokemonName: String, pokemonImage: UIImage) {
        self.pokemonUrl = pokemonUrl
        self.pokemonName = pokemonName
        self.pokemonImage = pokemonImage
        _vm = StateObject(
            wrappedValue: PokemonDetailViewModel(
                pokemonDetailService: PokemonDetailService(),
                pokemonUrl: pokemonUrl
            )
        )
    }

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            switch vm.state {
            case .idle, .loading:
                ProgressView("Loading \(pokemonName.capitalized)...")
                    .progressViewStyle(.circular)
                    .tint(.blue)
                    .font(.headline)

            case .error(let message):
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task { await vm.fetchData() }
                    }
                    .buttonStyle(.borderedProminent)
                }

            case .success(let pokemon):
                ScrollView {
                    VStack(spacing: 20) {
                        HeaderSection(
                            pokemonImage: pokemonImage,
                            pokemonName: pokemonName,
                            pokemon: pokemon
                        )
                        InfoSection(pokemon: pokemon)
                        EvolutionSection(pokemon: pokemon)
                    }
                    .padding()
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .navigationTitle(pokemonName.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchData()
        }
    }


    // MARK: - Helpers
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [.blue.opacity(0.15), .purple.opacity(0.2)],
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
