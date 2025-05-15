//
//  PokemonTypeColor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 15.05.2025.
//

import UIKit

enum PokemonTypeColor {
    static func color(for type: String) -> UIColor {
        switch type.lowercased() {
        case "green":
                .systemGreen
        case "red":
                .systemRed
        case "blue":
                .systemBlue
        case "yellow":
                .systemYellow
        default:
                .systemPurple
        }
    }

    static func progressColor(for value: Int) -> UIColor {
        switch value {
        case 0..<3:
                .systemRed
        case 3..<7:
                .systemYellow
        default:
                .systemGreen
        }
    }
}
