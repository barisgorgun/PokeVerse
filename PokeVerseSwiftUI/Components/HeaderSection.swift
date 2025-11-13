//
//  HeaderSection.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import SwiftUI
import CoreNetwork

struct HeaderSection: View {
    let pokemonImage: UIImage
    let pokemonName: String
    let pokemon: Pokemon

    @EnvironmentObject private var favorites: FavoriteListViewModel

    var body: some View {
        let item = PokemonDisplayItem(
            id: "\(pokemon.speciesDetail.id)",
            name: pokemonName,
            url: pokemon.speciesDetail.evolutionChain?.url ?? "",
            image: pokemonImage
        )

        let isFav = favorites.isFavorite(for: item.id)

        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: pokemonImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 6)

                Button {
                    Task {
                        await favorites.toggleFavorite(for: item)
                    }
                } label: {
                    Image(systemName: isFav ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundStyle(isFav ? .red : .secondary)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(8)
            }

            Text(pokemonName.capitalized)
                .font(.title.bold())
            Text("#\(pokemon.speciesDetail.id)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let genus = pokemon.speciesDetail.getLocalizedGenus() {
                Text(genus)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if let flavor = pokemon.speciesDetail.getLatestFlavorText() {
                Text(flavor)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 5)
    }
}
