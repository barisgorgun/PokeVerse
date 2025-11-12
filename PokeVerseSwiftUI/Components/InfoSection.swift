//
//  InfoSection.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import SwiftUI
import CoreNetwork

struct InfoSection: View {
    let pokemon: Pokemon

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Information")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Height: \(pokemon.pokemonDetails.height ?? 0)")
                    Text("Weight: \(pokemon.pokemonDetails.weight ?? 0)")
                    Text("Base XP: \(pokemon.pokemonDetails.baseExperience ?? 0)")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Spacer()
            }

            if let types = pokemon.pokemonDetails.types, !types.isEmpty {
                HStack {
                    ForEach(types, id: \.type?.name) { type in
                        if let name = type.type?.name {
                            Text(name.capitalized)
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(color(for: name)))
                                .foregroundColor(.white)
                        }
                    }
                }
            }

            if let stats = pokemon.pokemonDetails.stats, !stats.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(stats, id: \.stat?.name) { stat in
                        if let statName = stat.stat?.name, let value = stat.baseStat {
                            HStack {
                                Text(statName.capitalized)
                                    .font(.caption)
                                    .frame(width: 80, alignment: .leading)
                                ProgressView(value: Float(value), total: 200)
                                    .tint(.blue)
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 3)
    }

    private func color(for type: String) -> Color {
        switch type.lowercased() {
        case "fire":
            .red
        case "water":
            .blue
        case "grass":
            .green
        case "electric":
            .yellow
        case "psychic":
            .pink
        case "rock":
            .brown
        default:
            .gray
        }
    }
}
