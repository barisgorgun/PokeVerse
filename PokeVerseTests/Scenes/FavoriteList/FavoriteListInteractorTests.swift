//
//  FavoriteListInteractorTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 27.05.2025.
//

import XCTest

@testable import PokeVerse

final class FavoriteListInteractorTests: XCTestCase {
    private var interactor: FavoriteListInteractorProtocol!
    private var dataStore: MockFavoritePokemonDataStore!

    override func setUp() {
        super.setUp()
        dataStore = MockFavoritePokemonDataStore()
        interactor = FavoriteListInteractor(dataStore: dataStore)
    }

    override func tearDown() {
        super.tearDown()
        dataStore = nil
        interactor = nil
    }


}
