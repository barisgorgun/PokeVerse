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
    private var view: MockListView!
    private var router: MockPokeListRouter!

    override func setUp() {
        super.setUp()
        
        interactor = MockListInteractor()
        view = MockListView()
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
        XCTAssertFalse(interactor.fetchDataCalled)
        let expectation = XCTestExpectation(description: "fetchData called")

        interactor.onFetchDataCalled = {
            expectation.fulfill()
        }

        // When
        presenter.load()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(interactor.fetchDataCalled)
    }

    func test_loadMoreData_triggersInteractorFetchMoreData() {
        // Given
        XCTAssertFalse(interactor.fetchMoreDataCalled)
        let expectation = XCTestExpectation(description: "fetchMoreData called")

        interactor.onFetchMoreDataCalled = {
            expectation.fulfill()
        }

        // When
        presenter.loadMoreData()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(interactor.fetchMoreDataCalled)
    }

    func test_handleOutput_setLoading_updatesView() {
        // When
        presenter.handleOutput(.setLoading(true))

        // Then
        XCTAssertEqual(view.outputs, [.setLoading(true)])

        // When
        presenter.handleOutput(.setLoading(false))

        // Then
        XCTAssertEqual(view.outputs, [
            .setLoading(true),
            .setLoading(false)
        ])
    }

    func test_handleOutput_showPokeList_updatesListAndView() {
        // Given
        let mockPokemons = [
            Species(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            Species(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/")
        ]

        // When
        presenter.handleOutput(.showPokeList(mockPokemons))

        // Then
        XCTAssertEqual(view.outputs, [.showPokeList(mockPokemons)])
        XCTAssertEqual(presenter.pokeList, mockPokemons)
    }

    func test_handleOutput_showPokeList_appendsDataNotOverwrite() {
        // Given
        let firstBatch = [
            Species(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            Species(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/")
        ]

        let secondBatch = [
            Species(name: "arbok", url: "https://pokeapi.co/api/v2/pokemon-species/24/"),
            Species(name: "sandshrew", url: "https://pokeapi.co/api/v2/pokemon-species/27")
        ]

        // When
        presenter.handleOutput(.showPokeList(firstBatch))
        presenter.handleOutput(.showPokeList(secondBatch))

        // Then
        XCTAssertEqual(presenter.pokeList, firstBatch + secondBatch)
    }

    func test_handleOutput_showAlert_forwardsToView() {
        // Given
        let error = NetworkError.contentEmptyData
        let expectedAlert = Alert(message: error.localizedDescription)

        // When
        presenter.handleOutput(.showAlert(error))

        // Then
        XCTAssertEqual(view.outputs, [.showAlert(expectedAlert)])
    }

    func test_didSelectPoke_withValidIndex_navigatesToDetail() {
        // Given
        let mockPokemons = [
            Species(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            Species(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/")
        ]
        presenter.handleOutput(.showPokeList(mockPokemons))

        // When
        presenter.didSelectPoke(at: .zero)

        // Then
        XCTAssertTrue(router.goToDetailPageCalled)
        XCTAssertEqual(router.receivedURL, "https://pokeapi.co/api/v2/pokemon/25/")
    }

    func test_didSelectPoke_withInvalidIndex_doesNothing() {
        // Given
        let mockPokemons = [
            Species(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            Species(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/6/")
        ]
        presenter.handleOutput(.showPokeList(mockPokemons))

        // When
        presenter.didSelectPoke(at: 3)

        // Then
        XCTAssertFalse(router.goToDetailPageCalled)
    }
}


// MARK: - PokeListViewProtocol

private final class MockListView: PokeListViewProtocol {
    var outputs: [PokeListPresenterOutput] = []

    func handleOutput(_ output: PokeListPresenterOutput) {
        outputs.append(output)
    }
}

// MARK: - PokeListInteractorProtocol

private final class MockListInteractor: PokeListInteractorProtocol {
    var delegate: (any PokeListInteractorDelegate)?
    var fetchDataCalled = false
    var onFetchDataCalled: (() -> Void)?

    var fetchMoreDataCalled = false
    var onFetchMoreDataCalled: (() -> Void)?

    func fetchData() async {
        fetchDataCalled = true
        onFetchDataCalled?()
    }
    
    func fetchMoreData() async {
        fetchMoreDataCalled = true
        onFetchMoreDataCalled?()
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
