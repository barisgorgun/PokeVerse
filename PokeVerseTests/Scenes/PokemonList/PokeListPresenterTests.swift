//
//  PokeListPresenterTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 17.05.2025.
//

import XCTest

@testable import PokeVerse

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

    func test_load_triggersInteractorFetchData() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for fetchData")
        XCTAssertFalse(interactor.fetchDataCalled)

        // When
        presenter.load()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.interactor.fetchDataCalled)
            XCTAssertNotNil(self.view.species)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }


    func test_load_showsAlertOnFailure() {
        // Given
        let expectedError = NetworkError.contentEmptyData
        interactor.fetchDataResult = .failure(expectedError)

        let expectation = expectation(description: "Wait for presenter.load() to finish")

        // When
        presenter.load()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.showAlertCalled)
            XCTAssertEqual(self.view.capturedAlert?.message, "Sunucudan geçerli bir veri alınamadı.")
            XCTAssertEqual(self.view.species, [])
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_prefetchIfNeeded_triggersLoadMoreWhenNearThreshold() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for fetchMoreData")
        XCTAssertFalse(interactor.fetchMoreDataCalled)

        // When
        presenter.prefetchIfNeeded(for: [IndexPath(row: 6, section: 0)])

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.interactor.fetchMoreDataCalled)
            XCTAssertNotNil(self.view.species)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor
    func test_prefetchIfNeeded_doesNothingWhenNotNearThreshold() {
        // Given
        XCTAssertFalse(interactor.fetchMoreDataCalled)

        // When
        presenter.prefetchIfNeeded(for: [IndexPath(row: 3, section: 0)])

        // Then
        XCTAssertFalse(interactor.fetchMoreDataCalled)
        XCTAssertEqual(view.species, [])
    }

    func test_loadMore_showsAlertOnFailure() {
        // Given
        let expectedError = NetworkError.contentEmptyData
        interactor.fetchMoreDataResult = .failure(expectedError)

        let expectation = expectation(description: "Wait for presenter.loadMore() to finish")

        // When
        presenter.prefetchIfNeeded(for: [IndexPath(row: 6, section: 0)])

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.view.showAlertCalled)
            XCTAssertEqual(self.view.capturedAlert?.message, "Sunucudan geçerli bir veri alınamadı.")
            XCTAssertEqual(self.view.species, [])
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor
    func test_didSelectPoke_navigatesToDetail() async {
        // Given
        interactor.fetchDataResult = .success([
            Species(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
            Species(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
        ])

        presenter.load()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // When
        presenter.didSelectPoke(at: 0)

        // Then
        XCTAssertTrue(router.goToDetailPageCalled)
        XCTAssertEqual(router.receivedURL, "https://pokeapi.co/api/v2/pokemon-species/1/")
    }

    @MainActor
    func test_didSelectPoke_invalidIndex_doesNotNavigate() async {
        // Given
        interactor.fetchDataResult = .success([
            Species(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
            Species(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/")
        ])

        presenter.load()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // When
        presenter.didSelectPoke(at: 5)

        // Then
        XCTAssertFalse(router.goToDetailPageCalled)
        XCTAssertNil(router.receivedURL)
    }
}


// MARK: - PokeListViewProtocol

@MainActor
final class MockPokeListView: PokeListViewProtocol {
    private(set) var capturedAlert: Alert?
    private(set) var showAlertCalled = false
    private(set) var species: [Species] = []

    func showPokeList(species: [Species]) {
        self.species = species
    }

    func showAlert(alert: Alert) {
        showAlertCalled = true
        capturedAlert = alert
    }

    func showLoading(isLoading: Bool) { }
}

// MARK: - PokeListInteractorProtocol

private final class MockListInteractor: PokeListInteractorProtocol {
    var fetchDataResult: Result<[Species], Error> = .success([])
    var fetchMoreDataResult: Result<[Species], Error> = .success([])

    private(set) var fetchDataCalled = false
    private(set) var fetchMoreDataCalled = false

    func fetchData() async -> Result<[Species], Error> {
        fetchDataCalled = true
        return fetchDataResult
    }

    func fetchMoreData() async -> Result<[Species], Error> {
        fetchMoreDataCalled = true
        return fetchMoreDataResult
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
