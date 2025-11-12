//
//  EvolutionSection.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import SwiftUI
import CoreNetwork

struct EvolutionSection: View {
    let pokemon: Pokemon
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Evolution Chain")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 36) {
                    ForEach(getEvolutionItems(from: pokemon.evolutionDetails.chain), id: \.name) { evo in
                        VStack {
                            AsyncImage(url: evo.imageURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 70, height: 70)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .background(Circle().fill(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)))
                                        .clipShape(Circle())
                                        .shadow(radius: 3)
                                case .failure:
                                    Image(systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }

                            Text(evo.name.capitalized)
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 3)
    }

    private struct EvolutionItem: Identifiable {
        let id = UUID()
        let name: String
        let imageURL: URL?
    }

    private func getEvolutionItems(from chain: ChainLink) -> [EvolutionItem] {
        var items: [EvolutionItem] = []

        if let id = chain.species.url.split(separator: "/").last(where: { !$0.isEmpty }) {
            let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
            items.append(EvolutionItem(name: chain.species.name, imageURL: imageURL))
        }

        for next in chain.evolvesTo {
            items.append(contentsOf: getEvolutionItems(from: next))
        }

        return items
    }
}
