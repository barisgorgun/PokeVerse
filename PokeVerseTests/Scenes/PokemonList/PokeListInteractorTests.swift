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
        case .success(let species):
            XCTAssertEqual(species, expectedList)
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
            XCTAssertTrue(error is NetworkError)
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
        case .success(let species):
            XCTAssertEqual(species, secondPageList)
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
            XCTAssertTrue(error is NetworkError)
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
            guard let networkError = error as? NetworkError else {
                return XCTFail("Expected NetworkError but got different error")
            }
            XCTAssertEqual(networkError, .contentEmptyData)
        }
    }

    // MARK: - Helper Methods

    private func setupTestEnvironment(with mockFile: String) {
        mockNetworkManager = MockNetworkManager()
        let service = PokemonListService(networkManager: mockNetworkManager)
        interactor = PokeListInteractor(pokeService: service)
    }

    private func resetTestEnvironment(with mockFile: String) {
        mockNetworkManager.updateMockFile(mockFile)
    }

    private func cleanUpTestEnvironment() {
        interactor = nil
        mockNetworkManager = nil
    }
}

// MARK: - MockNetworkManager

extension MockNetworkManager {

    func updateMockFile(_ fileName: String) {
        self.mockFileName = fileName
    }
}
