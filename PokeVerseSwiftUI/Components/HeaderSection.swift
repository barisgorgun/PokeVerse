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

    var body: some View {
        VStack(spacing: 8) {
            Image(uiImage: pokemonImage)
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 6)

            Text(pokemonName.capitalized)
                .font(.title.bold())
            Text("#\(pokemon.speciesDetail.id)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let genus = pokemon.speciesDetail.getLocalizedGenus() {
                Text(genus).font(.footnote).foregroundStyle(.secondary)
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
