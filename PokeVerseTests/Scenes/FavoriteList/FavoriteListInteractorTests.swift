//
//  FavoriteListInteractorTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 27.05.2025.
//

import XCTest

@testable import PokeVerse

final class FavoriteListInteractorTests: XCTestCase {
    private var interactor: FavoriteListInteractor!
    private var dataStore: MockFavoritePokemonDataStore!

    override func setUp() {
        super.setUp()
        dataStore = MockFavoritePokemonDataStore()
        interactor = FavoriteListInteractor(dataStore: dataStore)
    }

    override func tearDown() {
        dataStore = nil
        interactor = nil
        super.tearDown()
    }

    func test_removeFavoriteItem_shouldRemovePokemonFromFavorites() throws {
        // Given
        let pokemon = PokemonDisplayItem.mock(id: "123", isFavorite: true)
        try dataStore.saveFavorite(id: pokemon.id, name: pokemon.name, url: pokemon.url, image: pokemon.image)

        // When
        try interactor.removeFavoriteItem(withName: pokemon.id)

        // Then
        XCTAssertFalse(dataStore.isFavorite(id: "123"))
    }
}
