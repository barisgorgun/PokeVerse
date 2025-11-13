//
//  PokemonCardView.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import SwiftUI
import CoreNetwork

struct PokemonCardView: View {
    let item: PokemonDisplayItem
    let onTap: () -> Void

    @EnvironmentObject var favorites: FavoriteListViewModel

    var body: some View {
        let isFav = favorites.isFavorite(for: item.id)
        VStack(spacing: 8) {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 3, y: 2)

            Text(item.name.capitalized)
                .font(.headline)
                .foregroundStyle(.primary)

            Button {
                Task {
                    await favorites.toggleFavorite(for: item)
                }
            } label: {
                Image(systemName: isFav ? "heart.fill" : "heart")
                    .foregroundStyle(isFav ? .red : .gray)
                    .scaleEffect(isFav ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3), value: isFav)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 3)
        .onTapGesture { onTap() }
    }
}
