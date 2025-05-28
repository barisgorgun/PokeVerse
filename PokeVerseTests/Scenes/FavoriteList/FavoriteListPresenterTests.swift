//
//  FavoriteListPresenterTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 27.05.2025.
//

import XCTest

@testable import PokeVerse

@MainActor
final class FavoriteListPresenterTests: XCTestCase {
    private var presenter: FavoriteListPresenter!
    private var view: MockFavoriteView!
    private var router: MockFavoriteRouter!
    private var interactor: MockFavoriteListInteractor!

    override func setUp() async throws {
        try await super.setUp()
        view = await MainActor.run { MockFavoriteView() }
        router = MockFavoriteRouter()
        interactor = MockFavoriteListInteractor()
        presenter = FavoriteListPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
    }

    override func tearDown() {
        view = nil
        router = nil
        interactor = nil
        presenter = nil
        super.tearDown()
    }

    func test_load_fetchesFavoritesAndUpdatesView() async {
        // Given
        let expectedItems = [PokemonDisplayItem.mock(id: "001", name: "Bulbasaur")]
        interactor.mockFavorites = expectedItems

        // When
        await presenter.load()

        // Then
        XCTAssertEqual(view.reloadDataCalledWith, expectedItems)
        XCTAssertEqual(view.loadingStates, [true, false])
    }

    func test_load_showsAndHidesLoading() async {
        // When
        await presenter.load()

        // Then
        XCTAssertEqual(view.loadingStates, [true, false])
    }

    func test_didSelectPoke_navigatesToDetail() async {
        // Given
        let mockItem = PokemonDisplayItem.mock(id: "001", name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1")
        interactor.mockFavorites = [mockItem]
        await presenter.load()

        // When
        presenter.didSelectPoke(at: 0)

        // Then
        XCTAssertEqual(router.lastRoute, .detail("https://pokeapi.co/api/v2/pokemon/1"))
    }

    func test_didTapFavorite_removesItemAndReloadsList() async {
        // Given
        let mockItem = PokemonDisplayItem.mock(id: "001", name: "Bulbasaur")
        interactor.mockFavorites = [mockItem]
        await presenter.load()

        // When
        await presenter.didTapFavorite(at: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertEqual(interactor.removedId, "001")
        XCTAssertEqual(view.reloadDataCalledWith?.count, 0)
    }

    func test_didTapFavorite_throwsError_shouldShowAlert() async {
        // Given
        let mockItem = PokemonDisplayItem.mock(id: "001", name: "Bulbasaur")
        interactor.mockFavorites = [mockItem]
        await presenter.load()
        interactor.shouldThrowOnRemove = true

        // When
        await presenter.didTapFavorite(at: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertTrue(view.showAlertCalled)
    }

    func test_didReceiveFavoriteChange_shouldReloadFavorites() async {
        // Given
        let expectedItems = [PokemonDisplayItem.mock(id: "002", name: "Ivysaur")]
        interactor.mockFavorites = expectedItems

        // When
        await presenter.didReceiveFavoriteChange()

        // Then
        XCTAssertEqual(view.reloadDataCalledWith, expectedItems)
    }
}

// MARK: - MockFavoriteView

private final class MockFavoriteView: FavoriteListViewProtocol {
    var reloadDataCalledWith: [PokemonDisplayItem]?
    var loadingStates: [Bool] = []
    var showAlertCalled = false

    func reloadData(with species: [PokemonDisplayItem]) {
        reloadDataCalledWith = species
    }

    func showLoading(isLoading: Bool) {
        loadingStates.append(isLoading)
    }

    func showAlert(alert: Alert) {
        showAlertCalled = true
    }
}

// MARK: - MockFavoriteRouter

private final class MockFavoriteRouter: FavoriteListRouterProtocol {
    var lastRoute: PokeListRoute?

    func navigate(to route: PokeListRoute) {
        lastRoute = route
    }
}

// MARK: - MockFavoriteListInteractor

private final class MockFavoriteListInteractor: FavoriteListInteractorProtocol {
    var mockFavorites : [PokemonDisplayItem] = []
    var removedId: String?
    var shouldThrowOnRemove = false

    func removeFavoriteItem(withName id: String) throws {
        removedId = id
        if shouldThrowOnRemove {
            throw CoreDataError.invalidData
        }
        mockFavorites.removeAll { $0.id == id }
    }

    func getFavoriteList() async -> [PokemonDisplayItem] {
        mockFavorites
    }
}
