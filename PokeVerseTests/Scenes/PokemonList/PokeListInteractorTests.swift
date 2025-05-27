//
//  PokeVerseTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import XCTest

@testable import PokeVerse

final class PokeListInteractorTests: XCTestCase {

    private var interactor: PokeListInteractor!
    private var mockNetworkManager: MockNetworkManager!
    private var mockDataStore: MockFavoritePokemonDataStore!

    override func setUp() {
        super.setUp()
        setupTestEnvironment(with: "species")
    }

    override func tearDown() {
        cleanUpTestEnvironment()
        super.tearDown()
    }

    func test_fetchData_returnsSpeciesList_onSuccess() async throws {
        // Given
        let expectedResponse: PokeSpecies = try mockNetworkManager.loadExpectedData(from: "species")
        let expectedList = expectedResponse.results

        // When
        let result = await interactor.fetchData()

        // Then
        switch result {
        case .success(let displayItems):
            XCTAssertEqual(displayItems.count, expectedList.count)
            XCTAssertEqual(displayItems[0].name, expectedList[0].name)
            XCTAssertEqual(displayItems[0].url, expectedList[0].url)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func test_fetchData_returnsFailure_onServiceError() async {
        // Given
        mockNetworkManager.shouldSucceed = false

        // When
        let result = await interactor.fetchData()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }

    func test_fetchMoreData_success() async throws {
        // Given
        _ = await interactor.fetchData()

        resetTestEnvironment(with: "speciesMore")
        let secondExpectedResponse: PokeSpecies = try mockNetworkManager.loadExpectedData(from: "speciesMore")
        let secondPageList = secondExpectedResponse.results

        // When
        let result = await interactor.fetchMoreData()

        // Then
        switch result {
        case .success(let displayItems):
            XCTAssertEqual(displayItems.count, secondPageList.count)
            XCTAssertEqual(displayItems[0].name, secondPageList[0].name)
            XCTAssertEqual(displayItems[0].url, secondPageList[0].url)
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }

    func test_fetchMoreData_failure() async {
        // Given
       _ = await interactor.fetchData()
        mockNetworkManager.shouldSucceed = false

        resetTestEnvironment(with: "speciesMore")

        // When
       let result = await interactor.fetchMoreData()


        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertNotNil(error)
        }
    }

    func test_fetchMoreData_whenNextURLIsNil_doesNotFetchData() async {
        // When
        let result = await interactor.fetchMoreData()

        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, .contentEmptyData)
        }
    }

    func test_toggleFavorite_addsPokemonToFavorites() throws {
        // Given
        let pokemon = PokemonDisplayItem.mock(id: "123", isFavorite: false)

        // When
        let result = try interactor.toggleFavorite(for: pokemon)

        // Then
        XCTAssertTrue(result, "Pokemon favorilere eklenmeli.")
        XCTAssertTrue(mockDataStore.isFavorite(id: "123"))
    }

    func test_toggleFavorite_removesPokemonFromFavorites() throws {
        // Given
        let pokemon = PokemonDisplayItem.mock(id: "123", isFavorite: true)
        try mockDataStore.saveFavorite(id: pokemon.id, name: pokemon.name, url: pokemon.url, image: pokemon.image)

        // When
        let result = try interactor.toggleFavorite(for: pokemon)

        // Then
        XCTAssertFalse(result, "Pokemon favorilerden kaldırılmalı.")
        XCTAssertFalse(mockDataStore.isFavorite(id: "123"))
    }

    func test_isFavorite_returnsTrue_whenPokemonIsInFavorites() {
        // Given
        mockDataStore.addToFavorites(id: "001")

        // When
        let result = interactor.isFavorite("001")

        // Then
        XCTAssertTrue(result)
    }

    func test_isFavorite_returnsFalse_whenPokemonIsNotInFavorites() {
        // When
        let result = interactor.isFavorite("999")

        // Then
        XCTAssertFalse(result)
    }



    // MARK: - Helper Methods

    private func setupTestEnvironment(with mockFile: String) {
        mockNetworkManager = MockNetworkManager()
        mockDataStore = MockFavoritePokemonDataStore()
        let service = PokemonListService(networkManager: mockNetworkManager)
        interactor = PokeListInteractor(pokeService: service, dataStore: mockDataStore)
    }

    private func resetTestEnvironment(with mockFile: String) {
        mockNetworkManager.updateMockFile(mockFile)
    }

    private func cleanUpTestEnvironment() {
        interactor = nil
        mockNetworkManager = nil
        mockDataStore = nil
    }
}

// MARK: - MockNetworkManager

extension MockNetworkManager {

    func updateMockFile(_ fileName: String) {
        self.mockFileName = fileName
    }
}
