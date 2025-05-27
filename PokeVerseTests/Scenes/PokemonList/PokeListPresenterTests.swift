//
//  PokeListPresenterTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 17.05.2025.
//

import XCTest

@testable import PokeVerse

@MainActor
final class PokeListPresenterTests: XCTestCase {

    private var presenter: PokeListPresenter!
    private var interactor: MockListInteractor!
    private var view: MockPokeListView!
    private var router: MockPokeListRouter!

    override func setUp() async throws {
        try await super.setUp()
        interactor = MockListInteractor()
        view = await MainActor.run { MockPokeListView() }
        router = MockPokeListRouter()

        presenter = PokeListPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
    }

    override func tearDown() {
        presenter = nil
        interactor = nil
        router = nil
        view = nil
        super.tearDown()
    }

    func test_load_showsAndHidesLoading() async {
        // Given
        interactor.fetchDataResult = .success([PokemonDisplayItem.mock()])

        // When
        await presenter.load()

        // Then
        XCTAssertEqual(view.loadingStates, [true, false])
    }

    func test_load_triggersInteractorFetchData() async {
        // Given
        XCTAssertFalse(interactor.fetchDataCalled)

        // When
        await presenter.load()

        // Then
        XCTAssertTrue(interactor.fetchDataCalled)
        XCTAssertNotNil(view.species)
    }

    func test_load_showsAlertOnFailure() async{
        // Given
        let expectedError = NetworkError.contentEmptyData
        interactor.fetchDataResult = .failure(expectedError)

        // When
        await presenter.load()

        // Then
        XCTAssertTrue(view.showAlertCalled)
        XCTAssertEqual(view.capturedAlert?.message, "error_contentEmptyData_message".localized())
        XCTAssertEqual(view.species.count, .zero)
    }

    func test_prefetchIfNeeded_triggersLoadMoreWhenNearThreshold() async {
        // Given
        XCTAssertFalse(interactor.fetchMoreDataCalled)

        // When
        await presenter.prefetchIfNeeded(for: [IndexPath(row: 6, section: 0)])

        // Then
        XCTAssertTrue(interactor.fetchMoreDataCalled)
        XCTAssertNotNil(view.species)
    }

    func test_prefetchIfNeeded_doesNothingWhenNotNearThreshold() async {
        // Given
        presenter.pokeList = Array(repeating: PokemonDisplayItem.mock(), count: 10)
        XCTAssertFalse(interactor.fetchMoreDataCalled)

        // When
        await presenter.prefetchIfNeeded(for: [IndexPath(row: 3, section: 0)])

        // Then
        XCTAssertFalse(interactor.fetchMoreDataCalled)
        XCTAssertEqual(view.species.count, .zero)
    }

    func test_loadMore_showsAlertOnFailure() async{
        // Given
        let expectedError = NetworkError.contentEmptyData
        interactor.fetchMoreDataResult = .failure(expectedError)

        // When
        await presenter.prefetchIfNeeded(for: [IndexPath(row: 6, section: 0)])

        // Then
        XCTAssertTrue(view.showAlertCalled)
        XCTAssertEqual(view.capturedAlert?.message, "error_contentEmptyData_message".localized())
        XCTAssertEqual(view.species.count, .zero)
    }

    func test_didSelectPoke_navigatesToDetail() async {
        // Given
        let items = PokemonDisplayItem.mock()
        interactor.fetchDataResult = .success([items])

        await presenter.load()

        // When
        presenter.didSelectPoke(at: 0)

        // Then
        XCTAssertTrue(router.goToDetailPageCalled)
        XCTAssertEqual(router.receivedURL, "https://pokeapi.co/api/v2/pokemon/1")
    }

    func test_didSelectPoke_invalidIndex_doesNotNavigate() async {
        // Given
        let items = PokemonDisplayItem.mock()
        interactor.fetchDataResult = .success([items])

        await presenter.load()

        // When
        presenter.didSelectPoke(at: 5)

        // Then
        XCTAssertFalse(router.goToDetailPageCalled)
        XCTAssertNil(router.receivedURL)
    }

    func test_didTapFavorite_togglesFavoriteStatusAndUpdatesView() async {
        // Given
        let pokemon = PokemonDisplayItem.mock(id: "99")
        interactor.fetchDataResult = .success([pokemon])
        await presenter.load()

        let indexPath = IndexPath(row: 0, section: 0)
        interactor.toggleFavoriteShouldSucceed = true

        // When
        await presenter.didTapFavorite(at: indexPath)

        // Then
        XCTAssertTrue(interactor.toggleFavoriteCalled)
        XCTAssertEqual(view.updatedIndexPath, indexPath)
        XCTAssertEqual(view.updatedFavoriteStatus, true)
    }

    func test_didTapFavorite_showsAlertOnFailure() async {
        // Given
        let pokemon = PokemonDisplayItem.mock(id: "42")
        interactor.fetchDataResult = .success([pokemon])
        await presenter.load()

        interactor.toggleFavoriteShouldThrow = true
        let indexPath = IndexPath(row: 0, section: 0)

        // When
        await presenter.didTapFavorite(at: indexPath)

        // Then
        XCTAssertTrue(view.showAlertCalled)
        XCTAssertEqual(view.capturedAlert?.message, CoreDataError.invalidData.localizedDescription)
    }

    func test_didTapFavorite_showsGenericAlertOnUnknownError() async {
        // Given
        let pokemon = PokemonDisplayItem.mock(id: "77")
        interactor.fetchDataResult = .success([pokemon])
        await presenter.load()

        interactor.toggleFavoriteShouldThrowUnknownError = true
        let indexPath = IndexPath(row: 0, section: 0)

        // When
        await presenter.didTapFavorite(at: indexPath)

        // Then
        XCTAssertTrue(view.showAlertCalled)
        XCTAssertEqual(view.capturedAlert?.message, "error_unexpected_message".localized())
    }

    func test_didReceiveFavoriteRemoval_updatesFavoriteStatus() async {
        // Given
        let pokemon = PokemonDisplayItem.mock(id: "100", isFavorite: true)
        interactor.fetchDataResult = .success([pokemon])
        await presenter.load()

        // When
        await presenter.didReceiveFavoriteRemoval(for: "100")

        // Then
        XCTAssertEqual(view.updatedIndexPath?.row, 0)
        XCTAssertEqual(view.updatedFavoriteStatus, false)
    }

    func test_isFavorite_returnsInteractorResult() {
        // Given
        let interactor = MockListInteractor()
        interactor.favoriteIDs = ["123"]
        presenter = PokeListPresenter(view: view, interactor: interactor, router: router)

        // When
        let result = presenter.isFavorite(at: "123")

        // Then
        XCTAssertTrue(result)
    }
}


// MARK: - PokeListViewProtocol

@MainActor
final class MockPokeListView: PokeListViewProtocol {
    private(set) var capturedAlert: Alert?
    private(set) var showAlertCalled = false
    private(set) var species: [PokemonDisplayItem] = []
    private(set) var updatedIndexPath: IndexPath?
    private(set) var updatedFavoriteStatus: Bool?
    var loadingStates: [Bool] = []

    func showPokeList(species: [PokemonDisplayItem]) {
        self.species = species
    }

    func showAlert(alert: Alert) {
        showAlertCalled = true
        capturedAlert = alert
    }

    func showLoading(isLoading: Bool) {
        loadingStates.append(isLoading)
    }

    func updateFavoriteStatus(at indexPath: IndexPath, isFavorite: Bool) {
        updatedIndexPath = indexPath
        updatedFavoriteStatus = isFavorite
    }
}

// MARK: - PokeListInteractorProtocol

private final class MockListInteractor: PokeListInteractorProtocol {
    var fetchDataResult: Result<[PokemonDisplayItem], NetworkError> = .success([])
    var fetchMoreDataResult: Result<[PokemonDisplayItem], NetworkError> = .success([])
    var favoriteIDs: [String] = []

    private(set) var fetchDataCalled = false
    private(set) var fetchMoreDataCalled = false

    var toggleFavoriteShouldSucceed = true
    var toggleFavoriteCalled = false
    var toggleFavoriteShouldThrow = false
    var toggleFavoriteShouldThrowUnknownError = false

    func fetchData() async -> Result<[PokemonDisplayItem], NetworkError> {
        fetchDataCalled = true
        return fetchDataResult
    }

    func fetchMoreData() async -> Result<[PokemonDisplayItem], NetworkError> {
        fetchMoreDataCalled = true
        return fetchMoreDataResult
    }

    func toggleFavorite(for pokemon: PokemonDisplayItem) throws -> Bool {
        toggleFavoriteCalled = true

        if toggleFavoriteShouldThrow {
            throw CoreDataError.invalidData
        }

        if toggleFavoriteShouldThrowUnknownError {
            throw NSError(domain: "test", code: -999, userInfo: nil)
        }

        return toggleFavoriteShouldSucceed
    }

    func isFavorite(_ id: String) -> Bool {
        favoriteIDs.contains(id)
    }
}

// MARK: - PokeListRouterProtocol

private final class MockPokeListRouter: PokeListRouterProtocol {
    var goToDetailPageCalled = false
    var receivedURL: String?

    func navigate(to route: PokeListRoute) {
        if case let .detail(url) = route {
            goToDetailPageCalled = true
            receivedURL = url
        }
    }
}
