//
//  PokemonDetailPresenterTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 18.05.2025.
//

import XCTest

@testable import PokeVerse

@MainActor
final class PokemonDetailPresenterTests: XCTestCase {

    private var presenter: PokemonDetailPresenter!
    private var view: MockDetailView!
    private var interactor: MockDetailInteractor!

    override func setUp() async throws {
        try await super.setUp()
        view = await MainActor.run { MockDetailView() }
        interactor = MockDetailInteractor()
        presenter = PokemonDetailPresenter(view: view, interactor: interactor)
    }

    override func tearDown() {
        view = nil
        interactor = nil
        presenter = nil
        super.tearDown()
    }

    func test_loadData_success_shouldShowPokemonAndStopLoading() async {
        // Given
        let mockPokemon = Pokemon.mock()
        interactor.resultToReturn = .success(mockPokemon)

        // When
        await presenter.loadData()

        // Then
        XCTAssertEqual(view.loadingStates, [true, false])
        XCTAssertEqual(view.shownPokemon?.speciesDetail.name, mockPokemon.speciesDetail.name)
    }

    func test_loadData_failure_shouldShowAlert() async {
        // Given
        interactor.resultToReturn = .failure(.contentEmptyData)

        // When
        await presenter.loadData()

        // Then
        XCTAssertEqual(view.loadingStates, [true, false])
        XCTAssertEqual(view.shownAlert?.message, NetworkError.contentEmptyData.userMessage)
    }

    func test_selectedControllerTapped_about_shouldShowAboutView() async {
        // Given
        let expectation = expectation(description: "showInfoView .about")
        view.onShowInfoView = { viewType in
            XCTAssertEqual(viewType, .about)
            expectation.fulfill()
        }

        // When
        presenter.selectedControllerTapped(at: 0)
        await fulfillment(of: [expectation], timeout: 1.0)

        // Then
        XCTAssertEqual(view.shownInfoView, .about)
    }

    func test_selectedControllerTapped_withValidIndex_shouldShowCorrectViewType() async {
        // Given
        let expectation = expectation(description: "Info view should be updated")

        view.onShowInfoView = { _ in
            expectation.fulfill()
        }

        // When
        presenter.selectedControllerTapped(at: 1)

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(view.shownInfoView, .stats)
    }

    func test_selectedControllerTapped_evolution_shouldShowEvolutionView() async {
        // Given
        let expectation = expectation(description: "showInfoView .evolution")
        view.onShowInfoView = { viewType in
            XCTAssertEqual(viewType, .evolution)
            expectation.fulfill()
        }

        // When
        presenter.selectedControllerTapped(at: 2)

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(view.shownInfoView, .evolution)
    }

    func test_selectedControllerTapped_invalidIndex_shouldDoNothing() {
        // When
        presenter.selectedControllerTapped(at: 999)

        // Then
        XCTAssertNil(view.shownInfoView)
    }
}

// MARK: - PokemonDetailViewProtocol

private final class MockDetailView: PokemonDetailViewProtocol {
    private(set) var loadingStates: [Bool] = []
    private(set) var shownPokemon: Pokemon?
    private(set) var shownAlert: Alert?
    private(set) var shownInfoView: DetailViewType?
    var onShowInfoView: ((DetailViewType) -> Void)?

    func showData(pokemon: Pokemon) {
        shownPokemon = pokemon
    }

    func showAlert(alert: Alert) {
        shownAlert = alert
    }

    func showLoading(isLoading: Bool) {
        loadingStates.append(isLoading)
    }

    func showInfoView(view: DetailViewType) {
        shownInfoView = view
        onShowInfoView?(view)
    }
}

// MARK: - PokemonDetailInteractorProtocol

private final class MockDetailInteractor: PokemonDetailInteractorProtocol {
    var resultToReturn: Result<Pokemon, NetworkError> = .failure(.contentEmptyData)
    private(set) var fetchDataCalled = false

    func fetchData() async -> Result<Pokemon, NetworkError> {
        fetchDataCalled = true
        return resultToReturn
    }
}
