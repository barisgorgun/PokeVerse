//
//  FavoritePokemon+CoreDataProperties.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 23.05.2025.
//

import Foundation
import CoreData

extension FavoritePokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritePokemon> {
        return NSFetchRequest<FavoritePokemon>(entityName: "FavoritePokemon")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
}

extension FavoritePokemon: Identifiable {}
