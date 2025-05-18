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
    private var presenter: MockPokeListePresenter!
    private var mockNetworkManager: MockNetworkManager!


    override func setUp() {
        super.setUp()
        setupTestEnvironment(with: "species")
    }

    override func tearDown() {
        cleanUpTestEnvironment()
        super.tearDown()
    }

    @MainActor
    func test_loadInitialData_success() async throws {
        // Given
        let expectedList = try mockNetworkManager.loadExpectedList(from: "species").results

        // When
        await interactor.fetchData()

        // Then
        XCTAssertEqual(
            presenter.outputs,
            [
                .setLoading(true),
                .setLoading(false),
                .showPokeList(expectedList)
            ]
        )
    }

    @MainActor
    func test_fetchData_failure() async {
        // Given
        mockNetworkManager.shouldSucceed = false

        // When
        await interactor.fetchData()

        // Then
        guard case .showAlert(let error) = presenter.outputs.last else {
            return XCTFail("Expected .showAlert as last output")
        }

        XCTAssertEqual(
            presenter.outputs,
            [
                .setLoading(true),
                .setLoading(false),
                .showAlert(error)
            ]
        )
    }

    @MainActor
    func test_fetchMoreData_success() async throws {
        // Given
        let firstPageList = try mockNetworkManager.loadExpectedList(from: "species").results

        // When
        await interactor.fetchData()

        // Then
        XCTAssertEqual(
            presenter.outputs,
            [
                .setLoading(true),
                .setLoading(false),
                .showPokeList(firstPageList)
            ]
        )

        // Given
        resetTestEnvironment(with: "speciesMore")
        let secondPageList = try mockNetworkManager.loadExpectedList(from: "speciesMore").results

        // When
        await interactor.fetchMoreData()


        // Then
        XCTAssertEqual(
            presenter.outputs,
            [
                .setLoading(true),
                .setLoading(false),
                .showPokeList(secondPageList)
            ]
        )
    }

    @MainActor
    func test_fetchMoreData_failure() async throws {
        // Given
        let firstPageList = try mockNetworkManager.loadExpectedList(from: "species").results

        // When
        await interactor.fetchData()

        // Then
        XCTAssertEqual(
            presenter.outputs,
            [
                .setLoading(true),
                .setLoading(false),
                .showPokeList(firstPageList)
            ]
        )

        // Given
        mockNetworkManager.shouldSucceed = false
        resetTestEnvironment(with: "speciesMore")

        // When
        await interactor.fetchMoreData()


        // Then
        guard case .showAlert(let error) = presenter.outputs.last else {
            return XCTFail("Expected .showAlert as last output")
        }
        XCTAssertEqual(
            presenter.outputs,
            [
                .setLoading(true),
                .setLoading(false),
                .showAlert(error)
            ]
        )
    }

    func test_fetchMoreData_whenNextURLIsNil_doesNotFetchData() async {
        // When
        await interactor.fetchMoreData()

        // Then
        XCTAssertEqual(presenter.outputs.count, .zero)
    }

    // MARK: - Helper Methods

    private func setupTestEnvironment(with mockFile: String) {
        presenter = MockPokeListePresenter()
        mockNetworkManager = MockNetworkManager(mockFileName: mockFile)
        let service = PokemonListService(networkManager: mockNetworkManager)
        interactor = PokeListInteractor(pokeService: service)
        interactor.delegate = presenter
    }

    private func resetTestEnvironment(with mockFile: String) {
        mockNetworkManager.updateMockFile(mockFile)
        presenter.clearOutputs()
    }

    private func cleanUpTestEnvironment() {
        interactor = nil
        presenter = nil
        mockNetworkManager = nil
    }
}

// MARK: - PokeListInteractorDelegate

private final class MockPokeListePresenter: PokeListInteractorDelegate {
    var outputs: [PokeListInteractorOutput] = []

    func handleOutput(_ output: PokeListInteractorOutput) {
        outputs.append(output)
    }

    func clearOutputs() {
        outputs.removeAll()
    }
}

// MARK: - MockNetworkManager

extension MockNetworkManager {

    func updateMockFile(_ fileName: String) {
        self.mockFileName = fileName
    }
}
