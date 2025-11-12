//
//  LoadingView.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import SwiftUI

struct LoadingView: View {
    let title: String

    var body: some View {
        VStack {
            ProgressView(title)
                .progressViewStyle(.circular)
                .tint(.blue)
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    LoadingView(title: "")
}
